import 'dart:convert';

import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:axpert_space/common/models/user_profile_model.dart';
import 'package:axpert_space/core/utils/server_connections/server_connections.dart';
import 'package:axpert_space/data/data_source/datasource_services.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:axpert_space/modules/task/models/task_row_options_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';
import '../../web_view/controller/web_view_controller.dart';
import '../models/task_action_model.dart';

class TaskController extends GetxController {
  final taskListPageViewIndex = 0.obs;
  final isTaskListLoading = false.obs;
  final isTaskOverviewLoading = false.obs;
  final pendingTaskCount = 0.obs;
  final taskListPageViewController = PageController();
  final taskList = [].obs;
  List<TaskListModel> mainTaskList = [];
  final isTaskRowOptionsLoading = false.obs;
  final isTaskDetailsRowOptionsExpanded = false.obs;

  final taskFilterExpandController = ExpansionTileController();
  var taskRowOptions = [].obs;
  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();
  WebViewController webViewController = Get.find();
  var taskSearchText = ''.obs;
  var searchController = TextEditingController();
  // taskFilter section

  // var taskFilterUserName = globalVariableController.USER_NAME;
  var taskFilterUserName = globalVariableController.USER_NAME.value.obs;
  var taskFilterShowTask = 'Open'.obs;
  var taskFilterPriority = 'ALL'.obs;
  var taskFilterTaskIdController = TextEditingController(text: "ALL");
  RxList<String> taskFilterUserNameList = <String>[].obs;
  final TextEditingController paramFilter_searchController = TextEditingController();
  var taskFilterShowTaskList = [
    'ALL',
    'Completed by',
    'Dropped by',
    'Initiated by me',
    'Open',
    'Returned to me by',
    'Sent by me to',
    'Sent to me by',
  ];
  var taskFilterPriorityList = ['ALL', 'High', 'Medium', 'Low', 'Show Stopper'];

  //-------------------

  // taskFilter chip section
  var taskFilterChipUserName = globalVariableController.USER_NAME.value.obs;
  var taskFilterChipShowTask = 'Open'.obs;
  var taskFilterChipPriority = 'ALL'.obs;
  var taskFilterChipTaskId = 'ALL'.obs;
  //-------------------

  //TaskDetailsPage
  var taskHistoryList = [].obs;
  var taskAttachmentList = [].obs;
  var isTaskDetailsLoading = false.obs;
  var isTaskAttachmentsLoading = false.obs;
  var showHistoryFlag = false.obs;
  var showHistoryContent = true.obs;
  // TaskListModel? _lastLoadedTask;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onShowHistoryIconClick() {
    showHistoryFlag.toggle();
  }

  void onHistoryWidgetAnimationEndCallBack() {
    showHistoryContent.toggle();
  }

  loadInitialData({bool force = false}) async {
    int newPage = taskListPageViewController.page?.round() ?? 0;
    if (newPage != taskListPageViewIndex.value) {
      taskListPageViewIndex.value = newPage;
    }
    if (taskList.isNotEmpty && !force) return;
    isTaskListLoading.value = true;
    isTaskOverviewLoading.value = true;
    await _getUserProfile();
    pendingTaskCount.value = await _getTaskPendingForToday();
    isTaskOverviewLoading.value = false;
    await _getAllUserNames();
    mainTaskList = taskList.value = await _getAllTaskList();
    isTaskListLoading.value = false;
  }

  onTaskSearch(String searchText) {
    taskSearchText.value = searchText;
    if (searchText.isEmpty) {
      searchController.text = '';
      taskList.value = mainTaskList;
    }
    taskList.value = mainTaskList
        .where((task) =>
            (task.caption.toLowerCase().contains(searchText.toLowerCase()) ||
                task.id.toLowerCase().contains(searchText.toLowerCase())) ||
            task.projectName.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  onTaskListViewSwitchButtonClick() {
    int newIndex = (taskListPageViewIndex.value + 1) % 3;
    if (taskListPageViewIndex.value == 2 && newIndex == 0) {
      taskListPageViewController.jumpToPage(0);
    } else {
      taskListPageViewController.animateToPage(
        newIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
    taskListPageViewIndex.value = newIndex;
  }

  getTaskWithFilter({bool reset = false}) async {
    isTaskListLoading.value = true;
    taskFilterExpandController.collapse();

    if (taskFilterTaskIdController.text.isEmpty ||
        taskFilterTaskIdController.text.length < 4) {
      taskFilterTaskIdController.text = 'ALL';
    }
    if (reset) {
      taskFilterUserName.value = globalVariableController.USER_NAME.value;
      taskFilterShowTask.value = 'Open';
      taskFilterTaskIdController.text = 'ALL';
      taskFilterPriority.value = 'ALL';
    }

    mainTaskList = taskList.value = await _getAllTaskList();
    isTaskListLoading.value = false;
  }

  updateFilterChipData() {
    taskFilterChipUserName.value = taskFilterUserName.value;
    taskFilterChipShowTask.value = taskFilterShowTask.value;
    taskFilterChipPriority.value = taskFilterPriority.value;
    taskFilterChipTaskId.value = taskFilterTaskIdController.text;
  }

  Future<void> loadTaskDetails({required TaskListModel task}) async {
    // if (_lastLoadedTask?.id == task.id) return;

    taskHistoryList.clear();
    taskAttachmentList.clear();
    // _lastLoadedTask = task;
    showHistoryFlag.value = false;
    isTaskDetailsLoading.value = true;
    isTaskAttachmentsLoading.value = true;
    isTaskRowOptionsLoading.value = true;
    isTaskDetailsRowOptionsExpanded.value = false;
    // await Future.delayed(Duration(seconds: 2));

    taskHistoryList.value = await _getTaskHistory(task.id);
    isTaskDetailsLoading.value = false;

    taskAttachmentList.value = await _getTaskAttachments(task.id);
    isTaskAttachmentsLoading.value = false;
  }

  bool onTaskDetailsPullUpDownCallBack(ScrollNotification notification) {
    if (isTaskDetailsLoading.value) return true;

    if (notification.metrics.pixels < -150) {
      if (!showHistoryFlag.value) {
        onShowHistoryIconClick();
      }
    } else if (notification.metrics.pixels >
        notification.metrics.maxScrollExtent + 100) {
      if (showHistoryFlag.value) {
        onShowHistoryIconClick();
      }
    }

    return true;
  }

  getTaskRowOptions(String taskId) async {
    isTaskRowOptionsLoading.value = true;
    // await Future.delayed(Duration(seconds: 2));
    taskRowOptions.value = await _getAllTaskRowList(taskId);

    isTaskRowOptionsLoading.value = false;
  }

  resetRowOptions() {
    taskRowOptions.clear();
  }

  toggleTaskDetailsRowOptions() {
    isTaskDetailsRowOptionsExpanded.toggle();
  }

  Future<int> _getTaskPendingForToday() async {
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETTASKSUMMARY,
      "sqlParams": {
        "username": globalVariableController.USER_NAME.value,
        "date": DateFormat('dd/MM/yyyy').format(DateTime.now())
      }
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        try {
          var overview = TaskOverviewModel.fromJson(dsDataList);
          return overview.data[0].pendingTodayCount;
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }

    return 0;
  }

  Future<List<TaskListModel>> _getAllTaskList() async {
    List<TaskListModel> taskList = [];

    LogService.writeLog(message: "_getAllTaskList()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GET_ALL_TASKS,
      "sqlParams": {
        "username": globalVariableController.USER_NAME.value,
        "person": taskFilterUserName.value,
        "showtasks": taskFilterShowTask.value,
        "priority": taskFilterPriority.value,
        "ptaskid": taskFilterTaskIdController.text
      }
      // "sqlParams": {"username": appStorage.retrieveValue(AppStorage.USER_NAME)}
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        for (var item in dsDataList) {
          try {
            if (item != null) {
              var task = TaskListModel.fromJson(item);
              taskList.add(task);
            }
          } catch (e) {
            debugPrint("_getAllTaskList()   $e");
          }
        }
      }
    }
    updateFilterChipData();
    return taskList;
  }

  _getAllUserNames() async {
    taskFilterUserNameList.value = [];

    LogService.writeLog(message: "_getAllUserNames()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GET_ALl_USERNAMES,
      "sqlParams": {}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        for (var item in dsDataList) {
          try {
            if (item != null) {
              taskFilterUserNameList.add(item["username"]);
            }
          } catch (e) {
            debugPrint(" $e");
          }
        }
      }
    }
  }

  _getUserProfile() async {
    LogService.writeLog(message: "_getUserProfile()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETUSERPROFILE,
      "sqlParams": {"username": globalVariableController.USER_NAME.value}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];

        try {
          var item = dsDataList[0];
          if (item != null) {
            var userProfile = UserProfileModel.fromJson(item);

            if (userProfile.gender.toString().toLowerCase().contains("male")) {
              globalVariableController.PROFILE_PICTURE.value =
                  "assets/icons/common/profile_male.png";
            } else {
              globalVariableController.PROFILE_PICTURE.value =
                  "assets/icons/common/profile_female.png";
            }
          }
        } catch (e) {
          debugPrint(" $e");
        }
      }
    }
  }

  Future<List<TaskRowOptionModel>> _getAllTaskRowList(String taskId) async {
    List<TaskRowOptionModel> taskRowList = [];

    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETACTIONLIST,
      "sqlParams": {
        "username": globalVariableController.USER_NAME.value,
        "taskid": taskId
      }
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        for (var item in dsDataList) {
          try {
            if (item != null) {
              var task = TaskRowOptionModel.fromJson(item);
              taskRowList.add(task);
            }
          } catch (e) {
            debugPrint("_getAllTaskRowList()   $e");
          }
        }
      }
    }

    return taskRowList;
  }

  Color getTaskActionColor(String action) {
    switch (action) {
      case "accep":
        return AppColors.chipCardWidgetColorGreen;
      case "sendtask":
        return AppColors.flatButtonColorBlue;
      case "return":
        return AppColors.chipCardWidgetColorViolet;
      case "infor":
        return AppColors.statusPending;
      case "loadhist":
        return AppColors.baseYellow;
      case "droptask":
        return AppColors.blue9;
      case "close":
        return AppColors.statusPending;
      case "status":
        return AppColors.flatButtonColorBlue;
      case "complete":
        return AppColors.chipCardWidgetColorGreen;
      default:
        return AppColors.blue9;
    }

    // switch (taskRowOption.action) {
    //   case "accep":
    //     tskJsn = tsk["command"][0];
    //     break;
    //   case "sendtask":
    //     tskJsn = tsk["command"][1];
    //     break;
    //   case "return":
    //     tskJsn = tsk["command"][8];
    //     break;
    //   case "infor":
    //     tskJsn = tsk["command"][7];
    //     break;
    //   case "loadhist":
    //     tskJsn = tsk["command"][2];
    //     break;
    //   case "droptask":
    //     tskJsn = tsk["command"][4];
    //     break;

    // }
  }

  Future<List<TaskHistoryModel>> _getTaskHistory(String taskId) async {
    List<TaskHistoryModel> taskHistoryList = [];
    LogService.writeLog(message: "_getTaskHistory()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETTASKHISTORY,
      "sqlParams": {"taskid": taskId}
      // "sqlParams": {"username": appStorage.retrieveValue(AppStorage.USER_NAME)}
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        for (var item in dsDataList) {
          try {
            var task = TaskHistoryModel.fromJson(item);
            taskHistoryList.add(task);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    return taskHistoryList;
  }

  Future<List<TaskAttachmentData>> _getTaskAttachments(String taskId) async {
    List<TaskAttachmentData> taskAttachmentData = [];
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETTASKATTACHMENTS,
      "sqlParams": {"taskid": taskId}
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        for (var item in dsDataList) {
          try {
            var data = TaskAttachmentData.fromJson(item);
            // taskHistoryList.add(task);
            taskAttachmentData.add(data);
          } catch (e) {
            print(e);
          }
        }
      }
    }

    return taskAttachmentData;
  }

  void acceptTaskTemp(TaskRowOptionModel taskRowOption, String taskId) {
    // AppStorage appStorage = AppStorage();
    Map tsk = {
      "command": [
        {
          "cmd": "opentstruct",
          "cmdval": "accp",
          "showin": "pop",
          "parentrefresh": "true",
          "pname": "taskid",
          "pvalue": taskId
        },
        {
          "cmd": "opentstruct",
          "cmdval": "send",
          "showin": "pop",
          "parentrefresh": "true",
          "pname": "taskid",
          "pvalue": taskId
        },
        {
          "cmd": "openiview",
          "cmdval": "history",
          "showin": "pop",
          "parentrefresh": "false",
          "pname": "tid",
          "pvalue": taskId
        },
        {
          "cmd": "opentstruct",
          "cmdval": "close",
          "showin": "pop",
          "parentrefresh": "true",
          "pname": "taskid",
          "pvalue": taskId
        },
        {
          "cmd": "opentstruct",
          "cmdval": "drop",
          "showin": "pop",
          "parentrefresh": "true",
          "pname": "taskid",
          "pvalue": taskId
        },
        {
          "cmd": "opentstruct",
          "cmdval": "stupd",
          "showin": "pop",
          "parentrefresh": "true",
          "pname": "taskid",
          "pvalue": taskId
        },
        {
          "cmd": "opentstruct",
          "cmdval": "taskc",
          "showin": "pop",
          "parentrefresh": "true",
          "pname": "taskid",
          "pvalue": taskId
        },
        {
          "cmd": "opentstruct",
          "cmdval": "infor",
          "showin": "pop",
          "parentrefresh": "true",
          "pname": "taskid",
          "pvalue": taskId
        },
        {
          "cmd": "opentstruct",
          "cmdval": "retun",
          "showin": "pop",
          "parentrefresh": "true",
          "pname": "taskid",
          "pvalue": taskId
        }
      ]
    };
    Map<String, dynamic> tskJsn = {};

    switch (taskRowOption.action) {
      case "accep":
        tskJsn = tsk["command"][0];
        break;
      case "sendtask":
        tskJsn = tsk["command"][1];
        break;
      case "return":
        tskJsn = tsk["command"][8];
        break;
      case "infor":
        tskJsn = tsk["command"][7];
        break;
      case "loadhist":
        tskJsn = tsk["command"][2];
        break;
      case "droptask":
        tskJsn = tsk["command"][4];
        break;
      case "close":
        tskJsn = tsk["command"][3];
        break;
      case "status":
        tskJsn = tsk["command"][5];
        break;
      case "complete":
        tskJsn = tsk["command"][6];
        break;
      default:
        tskJsn = tsk["command"][2];
        break;
    }
    var tskMOdel = TaskActionModel.fromJson(tskJsn);
    var transIdN = '';
    if (tskMOdel.cmd.contains("tstruct")) {
      transIdN = "t${taskRowOption.transid}";
    } else if (tskMOdel.cmd.contains("iview")) {
      transIdN = "i${taskRowOption.transid}";
    }

    var url =
        "${Const.BASE_WEB_URL}/aspx/AxMain.aspx?authKey=AXPERT-${appStorage.retrieveValue(AppStorage.SESSIONID)}&pname=$transIdN&params=^act=open^${tskMOdel.pName}~${tskMOdel.pValue}";

    webViewController.openWebView(url: url);
  }

  void navigateToCreateTask() {
    webViewController.navigateToCreateTask();
  }

  Widget highlightedText(String text, TextStyle style, {int maxLines = 2}) {
    if (taskSearchText.value.isEmpty) {
      return Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      );
    }

    final index =
        text.toLowerCase().indexOf(taskSearchText.value.toLowerCase());
    if (index == -1) {
      return Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      );
    }

    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      text: TextSpan(
        style: style,
        children: [
          TextSpan(
            text: text.substring(0, index),
          ),
          TextSpan(
            text: text.substring(index, index + taskSearchText.value.length),
            style: style.copyWith(
              // color: AppColors.baseYellow,
              background: Paint()..color = AppColors.baseYellow.withAlpha(100),
            ),
          ),
          TextSpan(text: text.substring(index + taskSearchText.value.length)),
        ],
      ),
    );
  }
}
