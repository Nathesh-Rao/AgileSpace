import 'dart:convert';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/app_storage/app_storage.dart';
import 'package:axpert_space/core/constants/const.dart';
import 'package:axpert_space/data/data_source/datasource_services.dart';
import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
import 'package:axpert_space/modules/notifications/service/notification_service.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/widgets/flat_button_widget.dart';
import '../../../core/config/config.dart';
import '../../../core/utils/server_connections/server_connections.dart';

class NotificationController extends GetxController {
  void notifyPrint(String msg) {
    debugPrint("NOTIFICATIONCONTROLLER : $msg");
  }

  var appStorage = AppStorage();
  var serverConnections = ServerConnections();
  GlobalVariableController globalVariableController = Get.find();

  RxList<FirebaseMessageModel> notifications = <FirebaseMessageModel>[].obs;
  RxList<FirebaseMessageModel> filteredNotifications =
      <FirebaseMessageModel>[].obs;
  RxMap<String, List<FirebaseMessageModel>> groupedNotifications =
      <String, List<FirebaseMessageModel>>{}.obs;

  var badgeCount = 0.obs;
  var showBadge = false.obs;
  var needRefreshNotification = false.obs;
  var notificationPageRefresh = false.obs;
  var selectedNotificationTYpe = "All".obs;
  var isNotificationScreenLoading = false.obs;
  var showNotify = false.obs;
  String fcmID = '';

  final Map<String, IconData> notificationTypeIcons = {
    "All": Icons.notifications_active,
    "Task": Icons.task_alt,
    "Leave": Icons.event_available,
    "Promotion": Icons.campaign,
    "Mail": Icons.mail,
  };

  IconData getNotificationIconByTypeAndAction(FirebaseMessageModel msg) {
    String type = msg.type.toLowerCase();

    if (type == "default") {
      return Icons.notifications_active;
    }
    if (type == "promotion") {
      return Icons.campaign;
    }
    if (type == "mail") {
      return Icons.mail;
    }
    if (type == "task") {
      try {
        final details = jsonDecode(msg.raw["task_details"]);
        final action = details["task_action"].toString().toLowerCase();
        switch (action) {
          case "created":
            return Icons.fiber_new;
          case "forwarded":
            return Icons.forward;
          case "updated":
            return Icons.edit;
          case "accepted":
            return Icons.check_circle;
          case "rejected":
            return Icons.cancel;
          default:
            return Icons.task_alt;
        }
      } catch (_) {
        return Icons.task_alt;
      }
    }
    if (type == "leave") {
      try {
        final details = jsonDecode(msg.raw["leave_details"]);
        final action = details["leave_action"].toString().toLowerCase();
        switch (action) {
          case "requested":
            return Icons.pending_actions;
          case "approved":
            return Icons.thumb_up;
          case "rejected":
            return Icons.thumb_down;
          default:
            return Icons.event_available;
        }
      } catch (_) {
        return Icons.event_available;
      }
    }
    return Icons.notifications;
  }

  @override
  void onInit() {
    super.onInit();
    AppNotificationsService().init();
    ever(globalVariableController.USER_NAME, (name) {
      if (name.isNotEmpty &&
          globalVariableController.PROJECT_NAME.value.isNotEmpty) {
        AppNotificationsService.cacheUserData();
        loadAllNotifications();
      }
      showNotify.value =
          appStorage.retrieveValue(AppStorage.isShowNotifyEnabled) ?? true;
    });

    ever(notifications, (_) {
      filterByType(selectedNotificationTYpe.value);
    });

    ever(selectedNotificationTYpe, (type) {
      filterByType(type);
    });

    ever(filteredNotifications, (_) {
      groupNotifications();
    });
  }

  void filterByType(String type) {
    selectedNotificationTYpe.value = type;
    if (type == "All") {
      filteredNotifications.assignAll(notifications);
      filteredNotifications.refresh();
      return;
    }
    filteredNotifications.assignAll(
      notifications.where(
        (n) => n.type.toLowerCase() == type.toLowerCase(),
      ),
    );
  }

  Future<void> loadAllNotifications() async {
    await mergeBackgroundNotifications();
    await _loadFromStorage();
    setBadgeCount();
    filterByType(selectedNotificationTYpe.value);
    groupNotifications();
  }

  Future<void> _loadFromStorage() async {
    notifications.clear();
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.USER_NAME.value;

    Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map projMap = all[project] ?? {};
    List userList = projMap[user] ?? [];

    for (var item in userList) {
      try {
        notifications.add(FirebaseMessageModel.fromJson(jsonDecode(item)));
      } catch (e) {
        notifyPrint(e.toString());
      }
    }
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void setBadgeCount() {
    int unreadCount = notifications.where((n) => n.isOpened == false).length;
    badgeCount.value = unreadCount;
    showBadge.value = unreadCount > 0;
  }

  void groupNotifications() {
    Map<String, List<FirebaseMessageModel>> groups = {
      "Today": [],
      "Yesterday": [],
      "Last 7 Days": [],
      "Older": [],
    };

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime last7 = today.subtract(const Duration(days: 7));

    for (var n in filteredNotifications) {
      DateTime ts = n.timestamp;
      DateTime d = DateTime(ts.year, ts.month, ts.day);

      if (d == today) {
        groups["Today"]!.add(n);
      } else if (d == yesterday) {
        groups["Yesterday"]!.add(n);
      } else if (d.isAfter(last7)) {
        groups["Last 7 Days"]!.add(n);
      } else {
        groups["Older"]!.add(n);
      }
    }
    groupedNotifications.value = groups;
  }

  Future<void> mergeBackgroundNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    List<String> bgList =
        prefs.getStringList(AppStorage.BG_NOTIFICATIONS) ?? [];
    notifyPrint("bgList.isEmpty => ${bgList.isEmpty}");
    if (bgList.isEmpty) return;

    Map allNotifications =
        appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map allUnread =
        appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    bool dataChanged = false;

    for (String item in bgList) {
      try {
        Map<String, dynamic> data = jsonDecode(item);

        var projectDetailsRaw = data['project_details'];
        Map<String, dynamic> projectDetails;

        if (projectDetailsRaw is String) {
          projectDetails = jsonDecode(projectDetailsRaw);
        } else {
          projectDetails = Map<String, dynamic>.from(projectDetailsRaw);
        }

        String project = projectDetails['projectname'];
        String user = projectDetails['notify_to'];

        Map projMap = allNotifications[project] ?? {};
        List userList = projMap[user] ?? [];

        bool exists = userList.any((e) {
          try {
            var existing = jsonDecode(e);
            return existing['timestamp'] == data['timestamp'] &&
                existing['notify_body'] == data['notify_body'];
          } catch (_) {
            return false;
          }
        });

        if (!exists) {
          userList.insert(0, item);
          projMap[user] = userList;
          allNotifications[project] = projMap;

          Map unreadProj = allUnread[project] ?? {};
          int current = int.tryParse(unreadProj[user] ?? "0") ?? 0;
          unreadProj[user] = "${current + 1}";
          allUnread[project] = unreadProj;

          dataChanged = true;
        }
      } catch (e) {
        notifyPrint(e.toString());
      }
    }

    if (dataChanged) {
      await appStorage.storeValue(
          AppStorage.NOTIFICATION_LIST, allNotifications);
      await appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, allUnread);
    }

    await prefs.remove(AppStorage.BG_NOTIFICATIONS);
  }

  void showClearAllDlg() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delete all notifications?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryActionColorDarkBlue,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                "All your notifications will be deleted and\nYou can't undo this process",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: FlatButtonWidget(
                      width: 100.w,
                      label: "Cancel",
                      color: AppColors.grey,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  20.horizontalSpace,
                  Expanded(
                    child: FlatButtonWidget(
                      width: 100.w,
                      label: "Delete",
                      color: AppColors.chipCardWidgetColorRed,
                      onTap: () async {
                        await deleteAllNotifications();
                        Get.back();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showDeleteSingleDlg(FirebaseMessageModel msg) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delete this notification?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryActionColorDarkBlue,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                "Selected notification will be deleted and\nYou can't undo this process",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: FlatButtonWidget(
                      width: 100.w,
                      label: "Cancel",
                      color: AppColors.grey,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  20.horizontalSpace,
                  Expanded(
                    child: FlatButtonWidget(
                      width: 100.w,
                      label: "Delete",
                      color: AppColors.chipCardWidgetColorRed,
                      onTap: () async {
                        await deleteNotification(msg);
                        Get.back();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> deleteAllNotifications() async {
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.USER_NAME.value;

    Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map unread = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};

    all[project]?[user] = [];
    unread[project]?[user] = "0";

    await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, all);
    await appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, unread);

    notifications.clear();
    badgeCount.value = 0;
    showBadge.value = false;

    needRefreshNotification.value = true;
    notificationPageRefresh.value = true;
  }

  Future<void> deleteNotification(FirebaseMessageModel model) async {
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.USER_NAME.value;

    Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    List userList = (all[project]?[user] ?? []).cast<String>();

    userList.removeWhere((e) {
      try {
        Map data = jsonDecode(e);
        return data['notify_title'] == model.title &&
            data['notify_body'] == model.body &&
            data['timestamp'] == model.timestamp.toIso8601String();
      } catch (_) {
        return false;
      }
    });

    all[project]?[user] = userList;
    await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, all);

    notifications.remove(model);
    needRefreshNotification.value = true;
    notificationPageRefresh.value = true;
  }

  String getDateForNotification(FirebaseMessageModel msg) {
    final DateTime ts = msg.timestamp;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime lastWeek = today.subtract(const Duration(days: 7));
    final DateTime dateOnly = DateTime(ts.year, ts.month, ts.day);

    if (dateOnly == today) {
      return _formatTime(ts);
    }
    if (dateOnly == yesterday) {
      return _formatTime(ts);
    }
    if (dateOnly.isAfter(lastWeek)) {
      return _getWeekday(ts.weekday);
    }
    return _formatFullDate(ts);
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    final int minute = time.minute;
    final String ampm = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final String minStr = minute.toString().padLeft(2, '0');
    return "$hour:$minStr $ampm";
  }

  String _getWeekday(int day) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[day - 1];
  }

  String _formatFullDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Future<void> onNotificationTileClick(FirebaseMessageModel msg) async {
    await markNotificationAsOpened(msg);
    setBadgeCount();
    await doActionByNotificationClick(msg);
  }

  Future<void> doActionByNotificationClick(FirebaseMessageModel msg) async {
    isNotificationScreenLoading.value = true;
    var type = msg.type;
    switch (type.toLowerCase()) {
      case "task":
        await _doTaskNotificationAction(msg);
        break;
      case "leave":
        await _doLeaveNotificationAction(msg);
        break;
      default:
        notifyPrint("Unknown notification type: $type");
        break;
    }
    isNotificationScreenLoading.value = false;
  }

  Future _doTaskNotificationAction(FirebaseMessageModel msg) async {
    notifyPrint(
        "clicked task-id ${jsonDecode(msg.raw["task_details"])["taskId"]}");
    try {
      var taskId = jsonDecode(msg.raw["task_details"])["taskId"];
      var taskModel = await getTaskById(taskId);
      isNotificationScreenLoading.value = false;
      if (taskModel != null) {
        Get.toNamed(
          AppRoutes.tasDetails,
          arguments: {"taskModel": taskModel},
        );
      } else {
        AppSnackBar.showError(
          "Task not found : $taskId",
          "We couldn't find the task with the taskid you provided",
        );
      }
    } catch (e) {
      isNotificationScreenLoading.value = false;
    }
  }

  Future _doLeaveNotificationAction(FirebaseMessageModel msg) async {
    notifyPrint(
        "clicked leave-id ${jsonDecode(msg.raw["leave_details"])["leaveId"]}");
    try {
      var recordId = jsonDecode(msg.raw["leave_details"])["leaveId"];
      var url =
          "${Const.BASE_WEB_URL}/aspx/AxMain.aspx?authKey=AXPERT-${appStorage.retrieveValue(AppStorage.SESSIONID)}&pname=tLeave";
      Get.toNamed(
        AppRoutes.webviewScreenForNotification,
        arguments: url,
      );
    } catch (e) {
      isNotificationScreenLoading.value = false;
    }
  }

  Future<TaskListModel?> getTaskById(String? id) async {
    TaskListModel? taskListModel;
    if (id == null) {
      return taskListModel;
    }
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETTASKDETAILS,
      "sqlParams": {"taskid": id}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        List dsDataList = jsonDSResp['result']['data'];
        if (dsDataList.isNotEmpty) {
          taskListModel = TaskListModel.fromJson(dsDataList.first);
        }
      }
    }
    return taskListModel;
  }

  Future<void> markNotificationAsOpened(FirebaseMessageModel msg) async {
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.USER_NAME.value;
    Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    List userList = (all[project]?[user] ?? []).cast<String>();

    for (int i = 0; i < userList.length; i++) {
      try {
        Map item = jsonDecode(userList[i]);
        if (item["notify_title"] == msg.title &&
            item["notify_body"] == msg.body &&
            item["timestamp"] == msg.timestamp.toIso8601String()) {
          item["is_opened"] = true;
          userList[i] = jsonEncode(item);
          break;
        }
      } catch (_) {}
    }
    all[project]?[user] = userList;
    await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, all);
    msg.isOpened = true;
    notifications.refresh();
    filteredNotifications.refresh();
    groupedNotifications.refresh();
  }

  Future<void> enableDisableNotification() async {
    showNotify.toggle();
    try {
      await appStorage.storeValue(
          AppStorage.isShowNotifyEnabled, showNotify.value);
    } catch (e) {
      notifyPrint("showNotify error $e");
    }
    notifyPrint("showNotify.value : ${showNotify.value}");
  }
}
