import 'dart:convert';

import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/log_service/log_services.dart';
import '../../../core/constants/const.dart';
import '../../../data/data_source/datasource_services.dart';
import '../leaves.dart';

// import '../../../common/common.dart';

class LeaveController extends GetxController {
  var isLeaveActivityLoading = false.obs;
  var isLeaveDetailsLoading = false.obs;
  var isLeaveHistoryLoading = false.obs;
  var leaveActivity = Rxn<LeaveActivityModel>();
  var leaveDetails = Rxn<LeaveDetailsModel>();
  var leaveHistoryList = RxList<LeaveHistoryModel>();
  var leaveCountRatio = 0.0.obs;
  var leaveDivisionsValue = RxList<double>();
  var appStorage = AppStorage();
  var serverConnections = ServerConnections();
  getLeaveActivity() async {
    if (leaveActivity.value != null) return;
    isLeaveActivityLoading.value = true;
    await Future.delayed(Duration(seconds: 3));
    leaveActivity.value = LeaveActivityModel.tempData;
    _setLeaveCountRatio();
    isLeaveActivityLoading.value = false;
  }

  _setLeaveCountRatio() {
    if (leaveActivity.value == null) return;
    leaveCountRatio.value = leaveActivity.value!.totalLeave == 0
        ? 0
        : leaveActivity.value!.balanceLeave / leaveActivity.value!.totalLeave;
  }

  getLeaveDetails() async {
    // if (leaveDetails.value != null) return;
    // leaveDetails.value = null;
    isLeaveDetailsLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    leaveDetails.value = LeaveDetailsModel.tempData;
    leaveDivisionsValue.value =
        calculateLeavePercentages(leaveDetails.value!.leaveBreakup);
    isLeaveDetailsLoading.value = false;
  }

  List<double> calculateLeavePercentages(List<LeaveBreakup> breakups) {
    int totalLeaves = breakups.fold(0, (sum, item) => sum + item.leaveNo);

    if (totalLeaves <= 0) {
      throw ArgumentError("Total leaves must be greater than zero");
    }

    return breakups.map((item) {
      return (item.leaveNo / totalLeaves) * 100;
    }).toList();
  }

  getLeaveHistory() async {
    // if (leaveHistoryList.isNotEmpty) return;
    isLeaveHistoryLoading.value = true;
    LogService.writeLog(message: "_getAllUserNames()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": "agilespace",
      "datasource": "DS_GETLEAVEHISTORY",
      "sqlParams": {"username": "shilpa"}
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
              leaveHistoryList.add(LeaveHistoryModel.fromJson(item));
            }
          } catch (e) {
            debugPrint(" $e");
          }
        }
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
}
