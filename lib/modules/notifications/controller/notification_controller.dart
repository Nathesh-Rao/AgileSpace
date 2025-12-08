// import 'dart:convert';

// import 'package:axpert_space/common/controller/global_variable_controller.dart';
// import 'package:axpert_space/core/app_storage/app_storage.dart';
// import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
// import 'package:axpert_space/modules/notifications/service/notification_service.dart';
// import 'package:axpert_space/modules/notifications/widgets/notification_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart'
//     show SharedPreferences;

// // class NotificationController extends GetxController {
// //   // NotificationController() {
// //   //   AppNotificationsService().init();
// //   // }

// //   notifyPrint(String msg) {
// //     debugPrint("NOTIFICATIONCONTROLLER : $msg");
// //   }

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     AppNotificationsService().init();
// //     // _setNotificationCount();
// //     loadAllNotifications();
// //   }

// //   var appStorage = AppStorage();
// //   GlobalVariableController globalVariableController = Get.find();
// //   var needRefreshNotification = false.obs;
// //   var notificationPageRefresh = false.obs;
// //   var badgeCount = 0.obs;
// //   var showBadge = false.obs;
// //   RxList<NotificationWidget> list = <NotificationWidget>[].obs;
// //   RxList<FirebaseMessageModel> notifications = <FirebaseMessageModel>[].obs;

// //   void deleteAllNotifications() {
// //     list.clear();

// //     appStorage.storeValue(AppStorage.NOTIFICATION_LIST, {});
// //     needRefreshNotification.value = true;
// //     notificationPageRefresh.value = true;
// //   }

// //   // _setNotificationCount() async {
// //   //   await mergeBackgroundNotifications();
// //   // }
// // // ---------------------------------------------------------------------------
// //   Future<void> loadAllNotifications() async {
// //     await mergeBackgroundNotifications();
// //     await _loadFromStorage();
// //     _setBadgeCount();
// //   }

// //   Future<void> _loadFromStorage() async {
// //     notifications.clear();

// //     String projectName = globalVariableController.PROJECT_NAME.value;
// //     String user = globalVariableController.NICK_NAME.value;

// //     Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
// //     Map projMap = all[projectName] ?? {};
// //     List userList = projMap[user] ?? [];

// //     for (var item in userList) {
// //       try {
// //         Map data = jsonDecode(item);
// //         notifications.add(FirebaseMessageModel.fromJson(data));
// //       } catch (e) {
// //         notifyPrint("Error parsing stored notification: $e");
// //       }
// //     }
// //   }

// //   void _setBadgeCount() {
// //     String project = globalVariableController.PROJECT_NAME.value;
// //     String user = globalVariableController.NICK_NAME.value;

// //     Map unread = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
// //     Map projectUnread = unread[project] ?? {};

// //     int count = int.tryParse(projectUnread[user] ?? "0") ?? 0;

// //     badgeCount.value = count;
// //     showBadge.value = count > 0;
// //   }

// // // ---------------------------------------------------------------------------

// //   Future<void> mergeBackgroundNotifications() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     List<String> bgList =
// //         prefs.getStringList(AppStorage.BG_NOTIFICATIONS) ?? [];
// //     notifyPrint("bgList: => $bgList");
// //     // if (bgList.isEmpty) return;

// //     Map allNotifications =
// //         appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
// //     Map allUnread =
// //         appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
// //     notifyPrint("allNotifications: => $allNotifications");
// //     notifyPrint("allUnread: => $allUnread");

// //     for (String item in bgList) {
// //       try {
// //         Map<String, dynamic> data = jsonDecode(item);

// //         var projectDetails = jsonDecode(data['project_details']);
// //         String project = projectDetails['projectname'].toString();
// //         String user = projectDetails['notify_to'].toString();

// //         Map projMap = allNotifications[project] ?? {};
// //         List userList = projMap[user] ?? [];

// //         userList.insert(0, item);

// //         projMap[user] = userList;
// //         allNotifications[project] = projMap;

// //         Map unreadProj = allUnread[project] ?? {};
// //         int current = int.tryParse(unreadProj[user]?.toString() ?? "0") ?? 0;
// //         unreadProj[user] = "${current + 1}";
// //         allUnread[project] = unreadProj;
// //       } catch (e) {
// //         notifyPrint("Error merging background notification: $e");
// //       }
// //     }

// //     await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, allNotifications);
// //     await appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, allUnread);

// //     await prefs.remove(AppStorage.BG_NOTIFICATIONS);
// //     debugPrint(
// //         "✅ Merged ${bgList.length} background notifications to main storage.");
// //   }

// //   Future<bool> getNotificationList() async {
// //     await mergeBackgroundNotifications();

// //     list.clear();

// //     var projectName = globalVariableController.PROJECT_NAME.value;
// //     var userName = globalVariableController.NICK_NAME.value;

// //     Map oldMessages =
// //         AppStorage().retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
// //     notifyPrint("oldMessages: => $oldMessages");

// //     Map projectWiseMessages = oldMessages[projectName] ?? {};
// //     notifyPrint("projectWiseMessages: => $projectWiseMessages");

// //     List notList = projectWiseMessages[userName] ?? [];
// //     notifyPrint("notList: => $notList");

// //     Map oldNotifyNum =
// //         AppStorage().retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
// //     Map projectWiseNum = oldNotifyNum[projectName] ?? {};
// //     var notNo = projectWiseNum[userName] ?? "0";

// //     if (notNo != "0") {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         badgeCount.value = int.parse(notNo);
// //         showBadge.value = true;
// //       });
// //     }

// //     if (notList.isEmpty) return false;

// //     for (var item in notList) {
// //       try {
// //         var val = jsonDecode(item);
// //         var notifyTo = val["notify_to"]?.toString().toLowerCase() ?? "";

// //         if (val['project_details'] == null) continue;

// //         var projectDet = jsonDecode(val['project_details']);

// //         if (projectDet["projectname"].toString() ==
// //                 globalVariableController.PROJECT_NAME.value &&
// //             notifyTo.contains(userName.toString().toLowerCase())) {
// //           list.add(NotificationWidget(
// //             message: FirebaseMessageModel.fromJson(val),
// //           ));
// //         }
// //       } catch (e) {
// //         notifyPrint("Error parsing notification item: $e");
// //       }
// //     }

// //     if (list.isEmpty) return false;
// //     return true;
// //   }

// //   Future<bool> deleteNotification(int index) async {
// //     bool? value;
// //     await Get.defaultDialog(
// //         title: "Delete?",
// //         middleText: "Do you want to delete this notification?",
// //         confirm: ElevatedButton(
// //           onPressed: () {
// //             Get.back();
// //             value = true;
// //             _deleteNotificationFromStorage(index);
// //           },
// //           child: Text("Yes"),
// //         ),
// //         cancel: TextButton(
// //             onPressed: () {
// //               Get.back();
// //               value = false;
// //             },
// //             child: Text("No")),
// //         barrierDismissible: false);
// //     return value ?? false;
// //   }

// //   _deleteNotificationFromStorage(int index) async {
// //     Map oldMessages =
// //         appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
// //     var projectName = globalVariableController.PROJECT_NAME.value;
// //     Map projectWiseMessages = oldMessages[projectName] ?? {};
// //     var userName = globalVariableController.NICK_NAME.value;
// //     List notiList = projectWiseMessages[userName] ?? [];

// //     notiList.removeAt(index);
// //     projectWiseMessages[userName] = notiList;
// //     oldMessages[projectName] = projectWiseMessages;

// //     await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, oldMessages);
// //     needRefreshNotification.value = true;
// //     notificationPageRefresh.value = true;
// //   }
// // }
// import 'dart:convert';
// import 'package:axpert_space/common/controller/global_variable_controller.dart';
// import 'package:axpert_space/core/app_storage/app_storage.dart';
// import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
// import 'package:axpert_space/modules/notifications/service/notification_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificationController extends GetxController {
//   notifyPrint(String msg) {
//     debugPrint("NOTIFICATIONCONTROLLER : $msg");
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     AppNotificationsService().init();
//     loadAllNotifications();
//   }

//   var appStorage = AppStorage();
//   GlobalVariableController globalVariableController = Get.find();

//   var badgeCount = 0.obs;
//   var showBadge = false.obs;
//   var needRefreshNotification = false.obs;
//   var notificationPageRefresh = false.obs;

//   RxList<FirebaseMessageModel> notifications = <FirebaseMessageModel>[].obs;
//   RxMap<String, List<FirebaseMessageModel>> groupedNotifications =
//       <String, List<FirebaseMessageModel>>{}.obs;

//   Future<void> loadAllNotifications() async {
//     await mergeBackgroundNotifications();
//     await _loadFromStorage();
//     _setBadgeCount();
//   }

//   Future<void> _loadFromStorage() async {
//     notifications.clear();
//     String project = globalVariableController.PROJECT_NAME.value;
//     String user = globalVariableController.NICK_NAME.value;

//     Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
//     Map projMap = all[project] ?? {};
//     List userList = projMap[user] ?? [];

//     for (var item in userList) {
//       try {
//         Map data = jsonDecode(item);
//         notifications.insert(0, FirebaseMessageModel.fromJson(data));
//       } catch (_) {}
//     }
//   }

//   void _setBadgeCount() {
//     String project = globalVariableController.PROJECT_NAME.value;
//     String user = globalVariableController.NICK_NAME.value;

//     Map unread = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
//     Map projUnread = unread[project] ?? {};
//     int count = int.tryParse(projUnread[user] ?? "0") ?? 0;

//     badgeCount.value = count;
//     showBadge.value = count > 0;
//   }

//   Future<void> mergeBackgroundNotifications() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> bgList =
//         prefs.getStringList(AppStorage.BG_NOTIFICATIONS) ?? [];

//     Map allNotifications =
//         appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
//     Map allUnread =
//         appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};

//     for (String item in bgList) {
//       try {
//         Map<String, dynamic> data = jsonDecode(item);
//         var projectDetails = jsonDecode(data['project_details']);
//         String project = projectDetails['projectname'];
//         String user = projectDetails['notify_to'];

//         Map projMap = allNotifications[project] ?? {};
//         List userList = projMap[user] ?? [];
//         userList.insert(0, item);
//         projMap[user] = userList;
//         allNotifications[project] = projMap;

//         Map unreadProj = allUnread[project] ?? {};
//         int current = int.tryParse(unreadProj[user]?.toString() ?? "0") ?? 0;
//         unreadProj[user] = "${current + 1}";
//         allUnread[project] = unreadProj;
//       } catch (_) {}
//     }

//     await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, allNotifications);
//     await appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, allUnread);
//     await prefs.remove(AppStorage.BG_NOTIFICATIONS);
//   }

//   Future<void> deleteAllNotifications() async {
//     String project = globalVariableController.PROJECT_NAME.value;
//     String user = globalVariableController.NICK_NAME.value;

//     Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
//     Map unread = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};

//     if (all[project] != null) all[project][user] = [];
//     if (unread[project] != null) unread[project][user] = "0";

//     await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, all);
//     await appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, unread);

//     notifications.clear();
//     badgeCount.value = 0;
//     showBadge.value = false;
//     needRefreshNotification.value = true;
//     notificationPageRefresh.value = true;
//   }

//   Future<void> deleteNotification(FirebaseMessageModel model) async {
//     String project = globalVariableController.PROJECT_NAME.value;
//     String user = globalVariableController.NICK_NAME.value;

//     Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
//     List userList = (all[project]?[user] ?? []).cast<String>();

//     userList.removeWhere((e) {
//       try {
//         Map data = jsonDecode(e);
//         return data['notify_title'] == model.title &&
//             data['notify_body'] == model.body;
//       } catch (_) {
//         return false;
//       }
//     });

//     all[project]?[user] = userList;
//     await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, all);

//     notifications.remove(model);
//     needRefreshNotification.value = true;
//     notificationPageRefresh.value = true;
//   }
// }

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
    // loadAllNotifications();
    // ever(notifications, (_) => groupNotifications());
    ever(globalVariableController.NICK_NAME, (name) {
      if (name.isNotEmpty &&
          globalVariableController.PROJECT_NAME.value.isNotEmpty) {
        notifyPrint("User detected ($name), loading notifications...");
        loadAllNotifications();
      }
    });

    ever(notifications, (_) => groupNotifications());
  }

  Future<void> loadAllNotifications() async {
    await mergeBackgroundNotifications();
    await _loadFromStorage();
    _setBadgeCount();
    groupNotifications();
  }

  Future<void> _loadFromStorage() async {
    notifications.clear();

    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.NICK_NAME.value;
    notifyPrint("LOADING STORAGE FOR: Project: '$project', User: '$user'");

    if (project.isEmpty || user.isEmpty) {
      notifyPrint("⚠️ WARNING: Project or User is empty. Skipping load.");
      return;
    }
    Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map projMap = all[project] ?? {};
    List userList = projMap[user] ?? [];

    for (var item in userList) {
      try {
        Map data = jsonDecode(item);
        notifications.add(FirebaseMessageModel.fromJson(data));
      } catch (e) {
        notifyPrint(e.toString());
      }
    }

    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void _setBadgeCount() {
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.NICK_NAME.value;

    Map unread = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    Map projUnread = unread[project] ?? {};
    int count = int.tryParse(projUnread[user] ?? "0") ?? 0;

    badgeCount.value = count;
    showBadge.value = count > 0;
  }

  void groupNotifications() {
    // notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyPrint("groupNotifications");
    Map<String, List<FirebaseMessageModel>> groups = {
      "Today": [],
      "Yesterday": [],
      "Last 7 Days": [],
      "Older": [],
    };

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime last7 = today.subtract(Duration(days: 7));

    for (var n in notifications) {
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
    notifyPrint("groupNotifications => ${groupedNotifications.value}");
  }

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
        int current = int.tryParse(unreadProj[user]?.toString() ?? "0") ?? 0;
        unreadProj[user] = "${current + 1}";
        allUnread[project] = unreadProj;
      } catch (e) {
        notifyPrint(e.toString());
      }
    }

    await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, allNotifications);
    await appStorage.storeValue(AppStorage.NOTIFICATION_UNREAD, allUnread);
    await prefs.remove(AppStorage.BG_NOTIFICATIONS);
  }

  Future<void> deleteAllNotifications() async {
    String project = globalVariableController.PROJECT_NAME.value;
    String user = globalVariableController.NICK_NAME.value;

    Map all = appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map unread = appStorage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};

    if (all[project] != null) all[project][user] = [];
    if (unread[project] != null) unread[project][user] = "0";

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
