// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:axpert_space/core/app_storage/app_storage.dart';
import 'package:axpert_space/modules/web_view/controller/web_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/common.dart';
import '../../../common/log_service/log_services.dart';
import '../../../core/core.dart';
import '../model/active_list_model.dart';
import '../model/bulk_approve_list_model.dart';
import '../model/pending_list_model.dart';
import '../widgets/active_list_bulk_approve_widget.dart';

class ActiveListController extends GetxController {
  final globalVariableController = Get.find<GlobalVariableController>();
  final webViewController = Get.find<WebViewController>();

  // PendingListController
  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();
  var body = {};
  var url = Const.getFullARMUrl(ServerConnections.API_GET_ALL_ACTIVE_TASKS);
  //----
  int pageNumber = 1;
  static const int pageSize = 40;
  var isListLoading = false.obs;
  var hasMoreData = true.obs;
  var isRefreshable = true.obs;
  var showFetchInfo = false.obs;
  RxList<ActiveTaskListModel> activeTaskList = <ActiveTaskListModel>[].obs;

  List<ActiveTaskListModel> activeTempList = [];
  //--------
  //--------
  RxMap<String, List<ActiveTaskListModel>> activeTaskMap =
      <String, List<ActiveTaskListModel>>{}.obs;
  var taskSearchText = ''.obs;
  TextEditingController searchTextController = TextEditingController();
  //-----
  late ScrollController taskListScrollController;
  late List<ExpandedTileController> expandedListControllers;
  //-----
  // Filter tasks
  var isFilterOn = false.obs;
  TextEditingController processNameController = TextEditingController();
  TextEditingController fromUserController = TextEditingController();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  var errDateFrom = ''.obs;
  var errDateTo = ''.obs;
  //-----
  //Bulk approval
  TextEditingController bulkCommentController = TextEditingController();
  var isBulkApprovalLoading = false.obs;
  var isBulkAppr_SelectAll = false.obs;
  var bulkApprovalCount_list = [].obs;
  var bulkApproval_activeList = [].obs;
  var showBulkApproveCommentError = false.obs;
  var isBulkApprovelSubmitLoading = false.obs;

  //-----
  @override
  void onInit() {
    taskListScrollController = ScrollController();
    taskListScrollController.addListener(() {
      if (taskListScrollController.position.pixels >=
          taskListScrollController.position.minScrollExtent + 100) {
        isRefreshable.value = false;
      } else {
        isRefreshable.value = true;
      }

      if (taskListScrollController.position.pixels >=
              taskListScrollController.position.maxScrollExtent &&
          !isListLoading.value &&
          hasMoreData.value) {
        fetchActiveTaskLists();
      }

      if (taskListScrollController.position.pixels >=
              taskListScrollController.position.maxScrollExtent - 100 &&
          !hasMoreData.value) {
        showFetchInfo.value = true;
      } else {
        showFetchInfo.value = false;
      }
    });

    super.onInit();
  }

  init() {
    if (activeTaskList.isEmpty) {
      hasMoreData.value = true;
      fetchActiveTaskLists();
    }
  }

  refreshList() {
    pageNumber = 1;
    hasMoreData.value = true;
    taskListScrollController
        .animateTo(taskListScrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 700), curve: Curves.decelerate)
        .then((_) {
      fetchActiveTaskLists(isRefresh: true);
    });
  }

  prepAPI({required int pageNo, required int pageSize}) {
    body = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      "AxSessionId": "meecdkr3rfj4dg5g4131xxrt",
      "AppName": globalVariableController.PROJECT_NAME.value.toString(),
      "Trace": "false",
      "PageSize": pageSize,
      "PageNo": pageNo,
      "Filter": "all"
    };
  }

  Future<void> fetchActiveTaskLists({bool isRefresh = false}) async {
    if (!hasMoreData.value) return;
    LogService.writeLog(message: " fetchActiveTaskLists() => started");
    isListLoading.value = true;
    activeTempList = [];
    prepAPI(pageNo: pageNumber, pageSize: pageSize);
    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);

    if (resp != "") {
      var jsonResp = jsonDecode(resp);

      if (jsonResp['result']['message'].toString().toLowerCase() == "success") {
        var activeList = jsonResp['result']['tasks'];

        for (var item in activeList) {
          ActiveTaskListModel activeListModel =
              ActiveTaskListModel.fromJson(item);
          activeTempList.add(activeListModel);
        }
      }
      if (activeTempList.isEmpty) {
        hasMoreData.value = false;
      } else {
        if (isRefresh) {
          activeTaskList.clear();
          activeTaskMap.value = {};
        }
        LogService.writeLog(
            message:
                "PageNumber: $pageNumber, PageSize: $pageSize, currentLength: ${activeTaskList.length}");

        activeTaskList.addAll(activeTempList);
        //-----------------------------------------
        _parseTaskMap();
        //----------------------------------------

        //----------------------------------------

        pageNumber++;
      }
    }

    isListLoading.value = false;
  }

  //search
  searchTask(String searchText) {
    taskSearchText.value = searchText;
    _parseTaskMap();
  }

  clearSearch() {
    if (Get.context != null) FocusScope.of(Get.context!).unfocus();
    searchTextController.clear();
    taskSearchText.value = '';
    _parseTaskMap();
  }

  bool _isFilterActive() {
    processNameController.text = fromUserController.text =
        dateFromController.text = dateToController.text = '';
    errDateFrom.value = errDateTo.value = '';

    return true;
  }

  _parseTaskMap() {
    activeTaskMap.value = {};
    // var filteredList = activeTaskList
    //     .where((t) => t.processname.toString().toLowerCase().contains(processNameController.text.toString().toLowerCase()))
    //     .toList();
    var filteredList = activeTaskList.where((t) => _filterTasks(t)).toList();
    for (var t in filteredList) {
      if (taskSearchText.value.isEmpty ||
          t.displaytitle
              .toString()
              .toLowerCase()
              .contains(taskSearchText.value.toString().toLowerCase()) ||
          t.displaycontent
              .toString()
              .toLowerCase()
              .contains(taskSearchText.value.toString().toLowerCase())) {
        activeTaskMap
            .putIfAbsent(categorizeDate(t.eventdatetime.toString()), () => [])
            .add(t);
      }
    }
  }

  removeFilter() {
    processNameController.text = fromUserController.text =
        dateFromController.text = dateToController.text = '';
    errDateFrom.value = errDateTo.value = '';

    _parseTaskMap();
  }

  applyFilter() {
    _parseTaskMap();
  }

  bool _filterTasks(ActiveTaskListModel task) {
    String processName = processNameController.text.trim().toLowerCase();
    String fromUser = fromUserController.text.trim().toLowerCase();
    String startDate = dateFromController.text.trim();
    String endDate = dateToController.text.trim();

    if (processName.isEmpty &&
        fromUser.isEmpty &&
        startDate.isEmpty &&
        endDate.isEmpty) {
      isFilterOn.value = false;
      return true;
    } else {
      isFilterOn.value = true;
    }

    bool matchesProcess = processName.isEmpty ||
        task.processname.toString().toLowerCase().contains(processName);
    bool matchesUser = fromUser.isEmpty ||
        task.fromuser.toString().toLowerCase().contains(fromUser);
    bool matchesDate = true;

    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      DateTime taskDate = DateFormat("dd/MM/yyyy HH:mm:ss")
          .parse(task.eventdatetime.toString());
      DateTime start = DateFormat("dd-MMM-yyyy").parse(startDate);
      DateTime end = DateFormat("dd-MMM-yyyy").parse(endDate);
      matchesDate = taskDate.isAfter(start) && taskDate.isBefore(end);
    }

    return matchesProcess && matchesUser && matchesDate;
  }

  String formatToDayTime(String dateString) {
    DateTime inputDate = DateFormat("dd/MM/yyyy HH:mm:ss").parse(dateString);
    String category = categorizeDate(dateString);

    if (category == "Today" || category == "Yesterday") {
      return DateFormat('h:mm a').format(inputDate);
    } else if (category == "This Week" || category == "Last Week") {
      return DateFormat('E d').format(inputDate);
    } else {
      return DateFormat('E M/yy').format(inputDate);
    }
  }

  String categorizeDate(String dateString) {
    DateTime inputDate = DateFormat("dd/MM/yyyy HH:mm:ss").parse(dateString);
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime lastWeekStart = startOfWeek.subtract(Duration(days: 7));
    DateTime lastWeekEnd = startOfWeek.subtract(Duration(days: 1));

    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastMonthStart = DateTime(now.year, now.month - 1, 1);
    DateTime lastMonthEnd = startOfMonth.subtract(Duration(days: 1));

    if (inputDate.isAfter(today)) {
      return "Today";
    } else if (inputDate.isAfter(yesterday)) {
      return "Yesterday";
    } else if (inputDate.isAfter(startOfWeek)) {
      return "This Week";
    } else if (inputDate.isAfter(lastWeekStart) &&
        inputDate.isBefore(lastWeekEnd)) {
      return "Last Week";
    } else if (inputDate.isAfter(startOfMonth)) {
      return "This Month";
    } else if (inputDate.isAfter(lastMonthStart) &&
        inputDate.isBefore(lastMonthEnd)) {
      return "Last Month";
    } else {
      return DateFormat('MMM yyyy').format(inputDate);
    }
  }

//--
  List<TextSpan> formatDateTimeSpan(String formattedDate) {
    final regex = RegExp(r'(\d{1,2}:\d{2})\s?(AM|PM)');
    final match = regex.firstMatch(formattedDate);

    if (match != null) {
      String timePart = match.group(1)!;
      String amPmPart = match.group(2)!;
      String prefix = formattedDate.replaceAll(match.group(0)!, '').trim();

      return [
        TextSpan(text: '$prefix '),
        TextSpan(text: timePart),
        TextSpan(
          text: ' $amPmPart',
          style: GoogleFonts.poppins(
            fontSize: 8,
            color: AppColors.textFieldMainTextColorBlueGrey,
            // color: Color(0xff666D80),
            fontWeight: FontWeight.w600,
          ),
        ),
      ];
    } else {
      return [
        TextSpan(
          text: formattedDate,
        )
      ];
    }
  }

  String formatSmartDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeStr = DateFormat('h:mm a').format(dateTime);
    final dayStr = DateFormat('EEE').format(dateTime);
    final dateStr = DateFormat('dd MMM yyyy').format(dateTime).toUpperCase();

    if (inputDate == today) {
      return timeStr;
    }

    if (today.difference(inputDate).inDays < 7) {
      return "$dayStr - $timeStr";
    }

    return "$dateStr - $timeStr";
  }

  //---
  Widget highlightedText(String text, TextStyle style, {bool isTitle = false}) {
    if (taskSearchText.value.isEmpty) {
      return Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: isTitle ? 1 : 2,
      );
    }

    final index =
        text.toLowerCase().indexOf(taskSearchText.value.toLowerCase());
    if (index == -1) {
      return Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: isTitle ? 1 : 2,
      );
    }

    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: isTitle ? 1 : 2,
      text: TextSpan(
        style: style.copyWith(color: Colors.black),
        children: [
          TextSpan(
            text: text.substring(0, index),
          ),
          TextSpan(
            text: text.substring(index, index + taskSearchText.value.length),
            style: TextStyle(
                color: AppColors.baseRed, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text.substring(index + taskSearchText.value.length)),
        ],
      ),
    );
  }

  Color getColorFromTaskTitle(String title) {
    if (title.toLowerCase().contains("month")) {
      // return AppColors.chipCardWidgetColorGreen;
      return AppColors.blue9;
    } else if (title.toLowerCase().contains("week")) {
      return AppColors.primaryActionIconColorBlue;
    } else if (title.toLowerCase().contains("today")) {
      return AppColors.baseRed;
    } else if (title.toLowerCase().contains("yesterday")) {
      return AppColors.chipCardWidgetColorViolet;
    }

    return AppColors.chipCardWidgetColorBlue;
  }

  void onTaskClick(ActiveTaskListModel task) async {
    var pendingModel = task.toPendingListModel();

    debugPrint(pendingModel.tasktype);
    switch (pendingModel.tasktype.toString().toUpperCase()) {
      case "MAKE":
        var URL = ServerConnections.activeList_CreateURL_MAKE(pendingModel);
        // if (!URL.isEmpty) Get.toNamed(Routes.InApplicationWebViewer, arguments: [Const.getFullWebUrl(URL)]);
        if (URL.isNotEmpty) {
          webViewController.openWebView(url: Const.getFullWebUrl(URL));
        }
        break;
      // break;
      case "CHECK":
      case "APPROVE":
        // listItemDetailsController.openModel = pendingModel;

        // print("Going to active details page");
        // //listItemDetailsController.fetchDetails();
        // await Get.toNamed(Routes.ProjectListingPageDetails);
        // print("returned from active details page");
        refreshList();

        break;
      case "":
      case "NULL":
      case "CACHED SAVE":
        var URL = ServerConnections.activeList_CreateURL_MESSAGE(pendingModel);
        if (URL.isNotEmpty) {
          webViewController.openWebView(url: Const.getFullWebUrl(URL));
        }
        pageNumber--;
        _parseTaskMap();

        break;
      default:
        break;
    }
  }

//bulk Approvel

  Future<void> getBulkApprovalCount() async {
    isBulkApprovalLoading.value = true;
    var url =
        Const.getFullARMUrl(ServerConnections.API_GET_BULK_APPROVAL_COUNT);
    var body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};

    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['message'].toString() == "success") {
        bulkApprovalCount_list.clear();
        var dataList = jsonResp['result']['data'];
        LogService.writeLog(message: "getBulkApprovalCount=> $dataList");
        for (var item in dataList) {
          BulkApprovalCountModel bulkApprovalCountModel =
              BulkApprovalCountModel.fromJson(item);
          bulkApprovalCount_list.add(bulkApprovalCountModel);
        }
      }
    }
    isBulkApprovalLoading.value = false;
  }

  Future<void> getBulkActiveTasks(String? processname) async {
    bulkApproval_activeList.clear();
    isBulkAppr_SelectAll.value = false;
    var url = Const.getFullARMUrl(ServerConnections.API_GET_BULK_ACTIVETASKS);
    var body = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      "AppName": globalVariableController.PROJECT_NAME.value.toString(),
      "tasktype": "Approve",
      "processname": processname,
      "touser": appStorage.retrieveValue(AppStorage.USER_NAME)
    };

    var resp = await serverConnections.postToServer(
        url: url, body: jsonEncode(body), isBearer: true);
    if (resp != "") {
      var jsonResp = jsonDecode(resp);
      if (jsonResp['result']['message'].toString() == "success") {
        var dataList = jsonResp['result']['data'];

        for (var item in dataList) {
          PendingListModel bulkApproval_activeTaskModel =
              PendingListModel.fromJson(item);
          bulkApproval_activeList.add(bulkApproval_activeTaskModel);
        }
      }
    }
  }

  selectAll_BulkApproveList_item(value) {
    isBulkAppr_SelectAll.value = value;
    for (var item in bulkApproval_activeList) {
      value == true
          ? item.bulkApprove_isSelected.value = true
          : item.bulkApprove_isSelected.value = false;
    }
  }

  onChange_BulkApproveItem(PendingListModel p, bool? value) {
    if (value == null) return;
    if (isBulkAppr_SelectAll.value == true) isBulkAppr_SelectAll.value = false;
    debugPrint("ON_TAP: $value");
    p.bulkApprove_isSelected.value = value;
    bulkApproval_activeList.refresh();
  }

  showBulkApprovalDlg() async {
    await getBulkApprovalCount();

    if (bulkApprovalCount_list.isEmpty) {
      AppSnackBar.showError("Empty Bulk Approval Lists",
          "There is no task available for bulk approval");
    } else {
      await Get.dialog(
          barrierDismissible: false,
          useSafeArea: false,
          ActiveListBulkApproveWidget());
    }
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

  Future doBulkApprove() async {
    showBulkApproveCommentError.value = false;

    var list_taskId = "";
    for (var item in bulkApproval_activeList) {
      if (item.bulkApprove_isSelected.value == true) {
        list_taskId.isEmpty
            ? list_taskId += item.taskid
            : list_taskId += "," + item.taskid;
      }
    }

    debugPrint("list_taskId: $list_taskId");

    if (list_taskId.isEmpty) {
      AppSnackBar.showError("Oops!", "Select atleast one task for approval.");
    } else if (bulkCommentController.text.isEmpty) {
      showBulkApproveCommentError.value = true;

      AppSnackBar.showError(
          "Comment is required", "Try again with proper Comment");
    } else {
      isBulkApprovelSubmitLoading.value = true;
      var url =
          Const.getFullARMUrl(ServerConnections.API_POST_BULK_DO_BULK_ACTION);
      var body = {
        "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
        "AxSessionId": "lqkrqbrwa3v3c2nmhq1dm1sk",
        "Trace": "true",
        "TaskId": list_taskId,
        "taskType": "APPROVE",
        "action": "BULKAPPROVE",
        "statusText": bulkCommentController.text,
        "AppName": globalVariableController.PROJECT_NAME.value.toString(),
        "user": appStorage.retrieveValue(AppStorage.USER_NAME)
      };
      var resp = await serverConnections.postToServer(
          url: url, body: jsonEncode(body), isBearer: true);

      print(resp);
      var jsonResp = jsonDecode(resp);
      // print(jsonResp['result']['success']);
      isBulkApprovelSubmitLoading.value = false;
      if (jsonResp["result"]["success"].toString() == "true") {
        Get.back();

        AppSnackBar.showSuccess("Bulk Approval success",
            "All ${list_taskId.split(",").length} tasks approved");
      } else {
        AppSnackBar.showError("Oops!", "Bulk action failed");
      }
    }
  }
}
