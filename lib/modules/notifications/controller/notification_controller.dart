import 'dart:convert';

import 'package:axpert_space/common/controller/global_variable_controller.dart';
import 'package:axpert_space/core/app_storage/app_storage.dart';
import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
import 'package:axpert_space/modules/notifications/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var appStorage = AppStorage();

  GlobalVariableController globalVariableController = Get.find();

  var needRefreshNotification = false.obs;
  var notificationPageRefresh = false.obs;

  var badgeCount = 0.obs;
  var showBadge = false.obs;
  // var list = [WidgetNotification(FirebaseMessageModel("Title 1", "Body 1"))];
  RxList<NotificationWidget> list = <NotificationWidget>[].obs;

  void deleteAllNotifications() {
    list.clear();

    appStorage.storeValue(AppStorage.NOTIFICATION_LIST, {});
    needRefreshNotification.value = true;
    notificationPageRefresh.value = true;
  }

  // getNotificationList() {
  //   list.clear();
  //   //get Noti List
  //   //doTheMergeProcess();

  //   List oldMessages =
  //       AppStorage().retrieveValue(AppStorage.NOTIFICATION_LIST) ?? [];

  //   //get Noti Count

  //   if (oldMessages.isNotEmpty) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       badgeCount.value = oldMessages.length;
  //       showBadge.value = true;
  //     });
  //   }

  //   if (oldMessages.isEmpty) return false;
  //   for (var item in oldMessages) {
  //     try {
  //       var val = jsonDecode(item);

  //       list.add(NotificationWidget(
  //         message: FirebaseMessageModel.fromJson(val),
  //       ));
  //     } catch (e) {
  //       debugPrint(e.toString());
  //     }
  //   }
  //   if (list.isEmpty) return false;
  //   return true;
  // }

  getNotificationList() {
    list.clear();
    //get Noti List
    //doTheMergeProcess();

    var projectName = globalVariableController.PROJECT_NAME.value;
    var userName = globalVariableController.USER_NAME.value;

    Map oldMessages =
        AppStorage().retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map projectWiseMessages = oldMessages[projectName] ?? {};
    List notList = projectWiseMessages[userName] ?? [];
    //get Noti Count
    Map oldNotifyNum =
        AppStorage().retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    Map projectWiseNum = oldNotifyNum[projectName] ?? {};
    var notNo = projectWiseNum[userName] ?? "0";
    if (notNo != "0") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        badgeCount.value = int.parse(notNo);
        showBadge.value = true;
      });
    }

    if (notList.isEmpty) return false;
    for (var item in notList) {
      try {
        var val = jsonDecode(item);
        var notifyTo = val["notify_to"].toString().toLowerCase();
        var projectDet = jsonDecode(val['project_details']);
        // print("notiiii: " + projectDet["projectname"].toString());
        if (projectDet["projectname"].toString() ==
                globalVariableController.PROJECT_NAME.value &&
            notifyTo.contains(userName.toString().toLowerCase())) {
          list.add(NotificationWidget(
            message: FirebaseMessageModel.fromJson(val),
          ));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    if (list.isEmpty) return false;
    return true;
  }

  Future<bool> deleteNotification(int index) async {
    bool? value;
    await Get.defaultDialog(
        title: "Delete?",
        middleText: "Do you want to delete this notification?",
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
            value = true;
            _deleteNotificationFromStorage(index);
          },
          child: Text("Yes"),
        ),
        cancel: TextButton(
            onPressed: () {
              Get.back();
              value = false;
            },
            child: Text("No")),
        barrierDismissible: false);
    return value ?? false;
  }

  _deleteNotificationFromStorage(int index) async {
    Map oldMessages =
        appStorage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    var projectName = globalVariableController.PROJECT_NAME.value;
    Map projectWiseMessages = oldMessages[projectName] ?? {};
    var userName = globalVariableController.USER_NAME.value;
    List notiList = projectWiseMessages[userName] ?? [];

    notiList.removeAt(index);
    projectWiseMessages[userName] = notiList;
    oldMessages[projectName] = projectWiseMessages;

    await appStorage.storeValue(AppStorage.NOTIFICATION_LIST, oldMessages);
    needRefreshNotification.value = true;
    notificationPageRefresh.value = true;
  }
}
