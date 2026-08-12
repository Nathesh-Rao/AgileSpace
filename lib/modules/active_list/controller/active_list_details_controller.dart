import 'dart:convert';
import 'dart:developer';

import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/core.dart';
import '../../web_view/controller/web_view_controller.dart';
import '../model/pending_list_model.dart';
import '../model/pending_process_flow_model.dart';
import '../model/pending_task_model.dart';

class ActiveListDetailsController extends GetxController {
  final globalVariableController = Get.find<GlobalVariableController>();
  final webViewController = Get.find<WebViewController>();
  String selectedTaskID = "";
  PendingListModel? openModel;
  var widgetProcessFlowNeedRefresh = true.obs;
  PendingTaskModel? pendingTaskModel;
  ServerConnections serverConnections = ServerConnections();
  var processFlowList = [].obs;
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 100 * 3.0);
  TextEditingController comments = TextEditingController();
  var errCom = ''.obs;
  var selected_processFlow_taskType = ''.obs;

  var ddSelectedValue = "Initiator".obs;
  var ddSendToUsers_SelectedValue = "".obs;
  var sendToUsersList = [].obs;
  AppStorage appStorage = AppStorage();
  var isActiveListDetailsLoading = false.obs;
  var isActiveListSendUserListLoading = false.obs;
  var isTaskDetailsRowOptionsExpanded = false.obs;
  fetchActiveListDetails() async {
    try {
      await fetchDetails();
    } catch (e) {
      AppSnackBar.showError("Oops", e.toString());
    }
  }

  void onProcessFlowItemTap(flow) {
    selected_processFlow_taskType.value = flow.tasktype.toString();
  }

  toggleTaskDetailsRowOptions() {
    isTaskDetailsRowOptionsExpanded.toggle();
  }

  String getDateValue(String? e) {
    if (e == null || e.isEmpty) return "";

    try {
      final date = DateFormat("dd/MM/yyyy HH:mm:ss").parse(e);

      final formatted =
          DateFormat("dd MMM yy - hh:mm a").format(date).toUpperCase();

      return formatted;
    } catch (er) {
      return e;
    }
  }

  fetchDetails(
      {hasArgument = false,
      PendingProcessFlowModel? pendingProcessFlowModel}) async {
    isActiveListDetailsLoading.value = true;
    // isActiveListDetailsBodyLoading.value = true;
    // LoadingScreen.show();
    var url = Const.getFullARMUrl(ServerConnections.API_GET_ACTIVETASK_DETAILS);
    Map<String, dynamic> body;
    var shouldCall = true;
    if (hasArgument) {
      if (pendingProcessFlowModel!.taskid.toString() == "" ||
          pendingProcessFlowModel.taskid.toString().toLowerCase() == "null") {
        shouldCall = false;
      }

      body = {
        'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
        "AppName": globalVariableController.PROJECT_NAME.value.toString(),
        "processname": pendingProcessFlowModel.processname,
        "tasktype": pendingProcessFlowModel.tasktype,
        "taskid": pendingProcessFlowModel.taskid,
        "keyvalue": pendingProcessFlowModel.keyvalue,
      };
      selectedTaskID = pendingProcessFlowModel.taskid;
      selected_processFlow_taskType.value = pendingProcessFlowModel.tasktype;
    } else {
      if (openModel!.taskid.toString() == "" ||
          openModel!.taskid.toString().toLowerCase() == "null") {
        shouldCall = false;
      }
      body = {
        'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
        "AppName": globalVariableController.PROJECT_NAME.value.toString(),
        "processname": openModel!.processname,
        "tasktype": openModel!.tasktype,
        "taskid": openModel!.taskid,
        "keyvalue": openModel!.keyvalue
      };
      selectedTaskID = openModel!.taskid;
      selected_processFlow_taskType.value = openModel!.tasktype;
    }
    if (!shouldCall) {
      widgetProcessFlowNeedRefresh.value = true;
      // LoadingScreen.dismiss();
      pendingTaskModel = null;
      isActiveListDetailsLoading.value = false;
      // isActiveListDetailsBodyLoading.value = false;

      return;
    }

    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);
    log("Fetch details => ${resp.toString()}");
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['message'].toString() == "success") {
        //process Flow ********************************
        if (!hasArgument) {
          var dataList = jsonResp['result']['processflow'];
          processFlowList.clear();
          for (var item in dataList) {
            PendingProcessFlowModel processFlowModel =
                PendingProcessFlowModel.fromJson(item);
            processFlowList.add(processFlowModel);
          }
        }

        // Task details *************************
        // var taskList = jsonResp['result']['taskdetails'];
        // for (var task in taskList) {
        //
        // }

        try {
          var task = jsonResp['result']['taskdetails'][0];
          if (task != null) {
            pendingTaskModel = PendingTaskModel.fromJson(task);
          } else {
            pendingTaskModel = null;
            // Get.snackbar("Oops!", "No details found!",
            //     duration: Duration(seconds: 1),
            //     snackPosition: SnackPosition.BOTTOM,
            //     backgroundColor: Colors.redAccent,
            //     colorText: Colors.white);
          }
        } catch (e) {
          pendingTaskModel = null;
        }

        // isActiveListDetailsBodyLoading.value = false;

        update(["detailsBody"]);

        log("Fetch Details => PendingTaskModel is null : ${pendingTaskModel == null}\nselected_processFlow_taskType.value : ${selected_processFlow_taskType.value}\nShoudcall : $shouldCall");
      }
    }
    // debugPrint("Length: ${processFlowList.length}");
    widgetProcessFlowNeedRefresh.value = true;
    // LoadingScreen.dismiss();
    isActiveListDetailsLoading.value = false;
  }

  void actionApproveOrRejectOrCheck(bool hasComments, action) async {
    debugPrint("Approve called 1");
    errCom.value = "";
    // if (hasComments) {
    //   if (comments.text.toString().trim() == "") errCom.value = "Please enter comments";
    //   return;
    // }
    debugPrint("Approve called 2");

    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "TaskId": pendingTaskModel!.taskid ?? "",
      "TaskType": pendingTaskModel!.tasktype ?? "",
      "Action": action,
      "StatusReason": "Approved by Manager",
      "StatusText": comments.text.toString().trim(),
    };
    debugPrint("Approve called 3");

    isActiveListDetailsLoading.value = true;
    var url = Const.getFullARMUrl(ServerConnections.API_DO_TASK_ACTIONS);
    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);
    debugPrint(resp.toString());
    isActiveListDetailsLoading.value = false;

    if (!resp.toString().contains("error")) {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['success'].toString().toLowerCase() == "true") {
        // PendingListController pendingListController = Get.find();
        // CompletedListController completedListController = Get.find();
        // pendingListController.getNoOfPendingActiveTasks();
        // completedListController.getNoOfCompletedActiveTasks();
        // Get.back();
        Get.back();
        showSuccessSnack("Done!", "Action Performed Successfully");
      } else {
        Get.back();
        showErrorSnack("Oops!", "Some Error Occured");
      }
    } else {
      showErrorSnack("Oops!", "Some Error Occured");
    }
  }

  void actionReturn(bool hasComments) async {
    errCom.value = "";
    if (hasComments) {
      if (comments.text.toString().trim() == "") {
        errCom.value = "Please enter comments";
      }
      return;
    }

    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "TaskId": pendingTaskModel?.taskid ?? "",
      "TaskType": pendingTaskModel?.tasktype ?? "",
      "Action": "Return",
      "StatusReason": "Performed by user",
      "StatusText": comments.text,
      "ReturnTo": ddSelectedValue.value
    };
    isActiveListDetailsLoading.value = true;

    var url = Const.getFullARMUrl(ServerConnections.API_DO_TASK_ACTIONS);
    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);
    isActiveListDetailsLoading.value = false;

    if (!resp.toString().contains("error")) {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['success'].toString().toLowerCase() == "true") {
        // PendingListController pendingListController = Get.find();
        // CompletedListController completedListController = Get.find();
        // pendingListController.getNoOfPendingActiveTasks();
        // completedListController.getNoOfCompletedActiveTasks();
        Get.back();
        Get.back();
        showSuccessSnack("Done!", "Action Performed Successfully");
      } else {
        Get.back();
        showErrorSnack("Oops!", "Some Error Occured");
      }
    } else {
      showErrorSnack("Oops!", "Some Error Occured");
    }
  }

  void actionSend(bool hasComments) async {
    errCom.value = "";
    if (hasComments) {
      if (comments.text.toString().trim() == "") {
        errCom.value = "Please enter comments";
      }
      return;
    }

    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "TaskId": pendingTaskModel?.taskid ?? "",
      "TaskType": pendingTaskModel?.tasktype ?? "",
      "Action": "Send",
      "StatusReason": "Performed by user",
      "StatusText": comments.text,
      "SendTo": ddSendToUsers_SelectedValue
    };
    isActiveListDetailsLoading.value = true;

    var url = Const.getFullARMUrl(ServerConnections.API_DO_TASK_ACTIONS);
    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);
    isActiveListDetailsLoading.value = false;

    if (!resp.toString().contains("error")) {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['success'].toString().toLowerCase() == "true") {
        // PendingListController pendingListController = Get.find();
        // CompletedListController completedListController = Get.find();
        // pendingListController.getNoOfPendingActiveTasks();
        // completedListController.getNoOfCompletedActiveTasks();
        Get.back();
        Get.back();
        showSuccessSnack("Done!", "Action Performed Successfully");
      } else {
        Get.back();
        showErrorSnack("Oops!", "Some Error Occured");
      }
    } else {
      showErrorSnack("Oops!", "Some Error Occured");
    }
  }

  showSuccessSnack(title, message) {
    AppSnackBar.showSuccess(title, message);
  }

  showErrorSnack(title, message) {
    AppSnackBar.showError(title, message);
  }

  List<String> dropdownMenuItem() {
    List<String> myList = [];

    myList.add("Initiator");
    myList.add("Previous Level");

    return myList;
  }

  dropDownItemChanged(String? value) {
    if (value != null) ddSelectedValue.value = value;
  }

  dropdownMenuItemSendToUsers() {
    List<String> myList = [];
    for (var item in sendToUsersList) {
      myList.add(item.toString());
    }
    return myList;
  }

  dropDownItemChangedSendToUsers(Object? value) {
    if (value != null) ddSendToUsers_SelectedValue.value = value.toString();
  }

  getSendToUsers_List() async {
    isActiveListSendUserListLoading.value = true;
    sendToUsersList.clear();
    var url = Const.getFullARMUrl(ServerConnections.API_GET_SENDTOUSERS);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "TaskId": pendingTaskModel?.taskid ?? "",
      "TaskType": pendingTaskModel?.tasktype ?? "",
      "TaskName": pendingTaskModel?.taskname ?? "",
      "KeyValue": pendingTaskModel?.keyvalue ?? ""
    };
    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);

    if (!resp.toString().contains("error")) {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['success'].toString().toLowerCase() == "true") {
        var jsonData = jsonDecode(resp)['result']['data'] as List;
        sendToUsersList.clear();
        for (var item in jsonData) {
          String val = item["pusername"].toString();
          sendToUsersList.add(val);
        }
        // sendToUsersList..sort((a, b) => a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
        if (ddSendToUsers_SelectedValue.value == "") {
          ddSendToUsers_SelectedValue.value = sendToUsersList[0];
          dropDownItemChangedSendToUsers(ddSendToUsers_SelectedValue);
        }
      } else {
        isActiveListSendUserListLoading.value = false;

        // Get.back();
        showErrorSnack(
            "Oops! No users found", jsonResp['result']['message'].toString());
      }
    } else {
      isActiveListSendUserListLoading.value = false;

      showErrorSnack("Oops! No users found", "Some Error Occured");
    }
    isActiveListSendUserListLoading.value = false;
  }

  void historyBtnClicked() {
    // var url =
    //     "${"aspx/AxMain.aspx?authKey=AXPERT-" + appStorage.retrieveValue(AppStorage.SESSIONID)}&pname=ipegtaskh&params=~pkeyvalue=${pendingTaskModel!.keyvalue}~pprocess=${pendingTaskModel!.processname}";

    var urlNew =
        "aspx/AxMain.aspx?authKey=AXPERT-${appStorage.retrieveValue(AppStorage.SESSIONID)}&pname=iad___pth&params=pkeyvalue~${pendingTaskModel!.keyvalue}^pprocess~${pendingTaskModel!.processname}";
    // Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullWebUrl(urlNew)]);

    webViewController.openWebView(url: Const.getFullWebUrl(urlNew));
  }

  void viewBtnClicked() {
    // var url =
    //     "${"aspx/AxMain.aspx?authKey=AXPERT-" + appStorage.retrieveValue(AppStorage.SESSIONID)}&pname=t${pendingTaskModel!.transid}&params=~act=load~recordid=${pendingTaskModel!.recordid}";
    var urlNew =
        "aspx/AxMain.aspx?authKey=AXPERT-${appStorage.retrieveValue(AppStorage.SESSIONID)}&pname=t${pendingTaskModel!.transid}&params=act~load^recordid~${pendingTaskModel!.recordid}";
    // Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullWebUrl(urlNew)]);
    webViewController.openWebView(url: Const.getFullWebUrl(urlNew));
  }
}
