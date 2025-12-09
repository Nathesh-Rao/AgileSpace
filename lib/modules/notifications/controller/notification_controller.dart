import 'dart:convert';
import 'package:axpert_space/common/controller/global_variable_controller.dart';
import 'package:axpert_space/core/app_storage/app_storage.dart';
import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
import 'package:axpert_space/modules/notifications/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  notifyPrint(String msg) {
    debugPrint("NOTIFICATIONCONTROLLER : $msg");
  }

  var appStorage = AppStorage();
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

  final Map<String, IconData> notificationTypeIcons = {
    "All": Icons.notifications_active,
    "Task": Icons.task_alt,
    "Leave": Icons.event_available,
    "Promotion": Icons.campaign,
    "Mail": Icons.mail,
  };

  @override
  void onInit() {
    super.onInit();
    AppNotificationsService().init();
    ever(globalVariableController.NICK_NAME, (name) {
      if (name.isNotEmpty &&
          globalVariableController.PROJECT_NAME.value.isNotEmpty) {
        loadAllNotifications();
      }
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

  // ---------------- FILTER LOGIC ----------------
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

    // filteredNotifications.refresh();
  }

  // ---------------- LOAD ALL ----------------

  Future<void> loadAllNotifications() async {
    await mergeBackgroundNotifications();
    await _loadFromStorage();
    _setBadgeCount();

    filterByType(selectedNotificationTYpe.value); // ensure correct view
    groupNotifications();
  }

  Future<void> _loadFromStorage() async {
    notifications.clear();

    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.NICK_NAME.value;

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

  // ---------------- BADGE COUNT ----------------

  void _setBadgeCount() {
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.NICK_NAME.value;

    Map unread = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    Map projUnread = unread[project] ?? {};
    int count = int.tryParse(projUnread[user] ?? "0") ?? 0;

    badgeCount.value = count;
    showBadge.value = count > 0;
  }

  // ---------------- GROUPING ----------------

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

  // ---------------- MERGE BG NOTIF ----------------

  Future<void> mergeBackgroundNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bgList =
        prefs.getStringList(AppStorage.BG_NOTIFICATIONS) ?? [];

    Map allNotifications =
        appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map allUnread =
        appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};

    for (String item in bgList) {
      try {
        Map<String, dynamic> data = jsonDecode(item);
        var projectDetails = jsonDecode(data['project_details']);

        String project = projectDetails['projectname'];
        String user = projectDetails['notify_to'];

        Map projMap = allNotifications[project] ?? {};
        List userList = projMap[user] ?? [];

        userList.insert(0, item);
        projMap[user] = userList;
        allNotifications[project] = projMap;

        Map unreadProj = allUnread[project] ?? {};
        int current = int.tryParse(unreadProj[user] ?? "0") ?? 0;

        unreadProj[user] = "${current + 1}";
        allUnread[project] = unreadProj;
      } catch (_) {}
    }

    await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, allNotifications);
    await appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, allUnread);
    await prefs.remove(AppStorage.BG_NOTIFICATIONS);
  }

  // ---------------- DELETE ALL ----------------

  Future<void> deleteAllNotifications() async {
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.NICK_NAME.value;

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

  // ---------------- DELETE SINGLE ----------------

  Future<void> deleteNotification(FirebaseMessageModel model) async {
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.NICK_NAME.value;

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
}
