import 'dart:convert';

import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/leaves/models/leave_overview_model.dart';
import 'package:axpert_space/modules/web_view/controller/web_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/log_service/log_services.dart';
import '../../../data/data_source/datasource_services.dart';
import '../leaves.dart';

// import '../../../common/common.dart';

class LeaveController extends GetxController {
  var isLeaveDetailsLoading = false.obs;
  var isLeaveOverviewLoading = false.obs;
  var isLeaveHistoryLoading = false.obs;

  var leaveHistoryList = RxList<LeaveHistoryModel>();
  var leaveCountRatio = 0.0.obs;
  var leaveDivisionsValue = RxList<double>();
  var appStorage = AppStorage();
  var serverConnections = ServerConnections();
  var leaveOverviewList = RxList<LeaveOverviewModel>();
  var leaveDetailsList = RxList<LeaveDetailsModel>();
  var totalLeaveTakenCount = 0.obs;
  var totalLeaveRemainingCount = 0.obs;
  WebViewController webviewController = Get.find();

  initializeLeaveData() async {
    await _getLeaveOverview();
    await _getLeaveDetails();
  }

  Future<void> _getLeaveOverview() async {
    isLeaveOverviewLoading.value = true;

    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETLEAVEOVERVIEW,
      "sqlParams": {"username": globalVariableController.USER_NAME.value}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        leaveOverviewList.clear();
        for (var item in dsDataList) {
          try {
            var event = LeaveOverviewModel.fromJson(item);
            leaveOverviewList.add(event);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    isLeaveOverviewLoading.value = false;
  }

  _setLeaveCountRatio() {
    totalLeaveTakenCount.value = 0;
    int totalLeaves =
        leaveDetailsList.fold(0, (sum, item) => sum + item.totalLeaves.toInt());

    int totalLeavesTaken = totalLeaveTakenCount.value =
        leaveDetailsList.fold(0, (sum, item) => sum + item.leavesTaken.toInt());
    totalLeaveRemainingCount.value = totalLeaves - totalLeavesTaken;
    if (totalLeaves == 0) {
      leaveCountRatio.value = 0;
    } else {
      leaveCountRatio.value = (totalLeaves - totalLeavesTaken) / totalLeaves;
    }
  }

  _getLeaveDetails() async {
    isLeaveDetailsLoading.value = true;

    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETLEAVEDETAILS,
      "sqlParams": {"username": globalVariableController.USER_NAME.value}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        leaveDetailsList.clear();
        for (var item in dsDataList) {
          try {
            var event = LeaveDetailsModel.fromJson(item);
            leaveDetailsList.add(event);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    leaveDivisionsValue.value = calculateLeavePercentages();
    _setLeaveCountRatio();
    isLeaveDetailsLoading.value = false;
  }

  List<double> calculateLeavePercentages() {
    int totalLeaves =
        leaveDetailsList.fold(0, (sum, item) => sum + item.totalLeaves.toInt());

    if (totalLeaves <= 0) {
      // throw ArgumentError("Total leaves must be greater than zero");
    }

    return leaveDetailsList.map((item) {
      final remaining = item.totalLeaves - item.leavesTaken;
      return (remaining / totalLeaves) * 100;
    }).toList();
  }

  getLeaveHistory() async {
    // if (leaveHistoryList.isNotEmpty) return;
    isLeaveHistoryLoading.value = true;
    LogService.writeLog(message: "_getAllUserNames()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETLEAVEHISTORY,
      "sqlParams": {"username": globalVariableController.USER_NAME.value}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        leaveHistoryList.value = [];
        var dsDataList = jsonDSResp['result']['data'];

        List<LeaveHistoryModel> temLeaveHistoryList = [];

        for (var item in dsDataList) {
          try {
            if (item != null) {
              temLeaveHistoryList.add(LeaveHistoryModel.fromJson(item));
            }
          } catch (e) {
            debugPrint(" $e");
          }
        }

        leaveHistoryList.value = temLeaveHistoryList;
      }
    }

    isLeaveHistoryLoading.value = false;
  }

  Color getLeaveProgressColor(double progress) {
    if (progress >= 0.75) {
      return Colors.green;
    } else if (progress >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color getColorByLeaveType(String leaveType) {
    switch (leaveType.toLowerCase()) {
      case 'annual leave':
        return Colors.blue;
      case 'sick leave':
        return Colors.red;
      case 'casual leave':
        return Colors.orange;
      case 'maternity leave':
        return Colors.pink;
      case 'paternity leave':
        return Colors.green;
      case 'earned leave':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData getIconByLeaveType(String leaveType) {
    switch (leaveType.toLowerCase()) {
      case 'annual leave':
        return Icons.beach_access;
      case 'sick leave':
        return Icons.healing;
      case 'casual leave':
        return Icons.weekend;
      case 'maternity leave':
        return Icons.child_friendly;
      case 'paternity leave':
        return Icons.family_restroom;
      case 'earned leave':
        return Icons.family_restroom;
      default:
        return Icons.event_note;
    }
  }

  Color getColorByLeaveStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getIconByLeaveStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  void applyForLeave() {
    // var url =
    //     "https://agileqa.agilecloud.biz/qaaxpert11.4base/aspx/AxMain.aspx?authKey=AXPERT-ARM-agilespaceqanew-8ca1f55c-3e6e-4526-bd55-460ca6d27ec6&pname=tLeave";

    // webviewController.openWebView(url: url);
  }

  List<Color> getColorList() {
    List<Color> colorList = List.generate(
        leaveDetailsList.length, (index) => AppColors.getNextColor());
    AppColors.resetColorIndex();
    return colorList;
  }
}
