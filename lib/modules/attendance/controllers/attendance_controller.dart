import 'dart:convert';

import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:axpert_space/modules/attendance/models/AttendanceReportModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';
import '../models/Attendance_detail_model.dart';

class AttendanceController extends GetxController {
  var attendanceAppbarSwitchValue = false.obs;
  var attendanceAppbarSwitchIsLoading = false.obs;
  var attendanceClockInWidgetCallBackValue = false.obs;
  var isAttendanceDetailsIsLoading = false.obs;
  var attendanceDetails = Rxn<AttendanceDetailsModel>();
  var isClockedIn = false.obs;
  var isClockedOut = false.obs;
  var clockInLocation = ''.obs;
  var clockOutLocation = ''.obs;
//----
  var attendanceDashboardIsLoading = false.obs;
  var attendanceState = AttendanceState.notPunchedIn.obs;
//-----
  var attendanceReportList = [].obs;
  var isAttendanceReportLoading = false.obs;
  var isLogExpanded = false.obs;
  var isLogExpandedAssist = false.obs;

  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();

  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  var years = [
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
  ];

  var selectedMonthIndex = DateTime.now().month.obs;
  var selectedYear = DateFormat("yyyy").format(DateTime.now()).obs;

  updateSelectedYear(dynamic date) {
    if (selectedYear.value == years[date]) return;
    selectedYear.value = years[date];
    _getAttendanceReport();
  }

  updateMonthIndex(int index) {
    if (selectedMonthIndex.value == index) return;
    selectedMonthIndex.value = index;
    _getAttendanceReport();
  }

  getAttendanceLog() {
    if (isLogExpanded.value) {
      switchLogExpandValue();
    }
    // isLogExpanded.value = false;
    if (attendanceReportList.isEmpty) {
      _getAttendanceReport();
    }
  }

  switchLogExpandValue() {
    isLogExpandedAssist.value = true;
    isLogExpanded.toggle();
  }

  _getAttendanceReport() async {
    isAttendanceReportLoading.value = true;
    var reportList = [];
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": "DS_GETATTENDANCELOG",
      "sqlParams": {"username": "malakonda", "month": "2025-08"}
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsData = jsonDSResp['result']['data'] ?? [];
        try {
          for (var l in dsData) {
            var log = AttendanceReportModel.fromJson(l);
            reportList.add(log);
          }
        } catch (e) {
          LogService.writeLog(message: "$e");
        }
      }
    }
    attendanceReportList.value = reportList;
    isAttendanceReportLoading.value = false;
  }

  onAttendanceAppbarSwitch(bool val) async {
    // attendanceAppbarSwitchIsLoading.value = true;
    // await Future.delayed(Duration(seconds: 2));
    // attendanceAppbarSwitchIsLoading.value = false;
    // attendanceClockInWidgetCallBackValue.value = true;
    // attendanceAppbarSwitchValue.value = !attendanceAppbarSwitchValue.value;
  }

  onAttendanceClockInCardClick() async {
    // attendanceAppbarSwitchIsLoading.value = true;
    // await Future.delayed(Duration(seconds: 2));
    // attendanceAppbarSwitchIsLoading.value = false;
    // attendanceClockInWidgetCallBackValue.value = true;
    // attendanceAppbarSwitchValue.value = !attendanceAppbarSwitchValue.value;
  }

  onAttendanceClockInAnimationEnd() {
    attendanceClockInWidgetCallBackValue.value = false;
  }

  //--------
  setAttendanceDashboard() {}

  //--------
  getInitialAttendanceDetails() async {
    if (attendanceDetails.value != null) return;
    isAttendanceDetailsIsLoading.value = true;
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": "DS_GETATTENDANCE_DETAIL",
      "sqlParams": {"username": "malakonda", "date": "19/08/2025"}
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsData = jsonDSResp['result']['data'][0] ?? '';
        try {
          attendanceDetails.value = AttendanceDetailsModel.fromJson(dsData);
          if (attendanceDetails.value != null) {
            await _setAttendanceStatus(attendanceDetails.value!);
          }
        } catch (e) {
          LogService.writeLog(message: "$e");
        }
      }
    }

    isAttendanceDetailsIsLoading.value = false;
  }

  _setAttendanceStatus(AttendanceDetailsModel value) async {
    if (value.outtime != null) {
      isClockedIn.value = isClockedOut.value = true;
      attendanceAppbarSwitchValue.value = true;
    } else if (value.intime != null && value.outtime == null) {
      isClockedIn.value = true;
      isClockedOut.value = false;
      attendanceAppbarSwitchValue.value = true;
    } else if (value.intime != null) {
      isClockedIn.value = isClockedOut.value = false;
      attendanceAppbarSwitchValue.value = false;
    }

    await _setLocationDetails(value);
  }

  _setLocationDetails(AttendanceDetailsModel value) async {
    if (value.intimeLatitude != null && value.intimeLongitude != null) {
      double latitude = double.tryParse(value.intimeLatitude ?? "") ?? 0.0;
      double longitude = double.tryParse(value.intimeLongitude ?? "") ?? 0.0;

      clockInLocation.value = await LocationUtils.getAddressFromLatLng(
          latitude: latitude, longitude: longitude);

      LogService.writeLog(message: clockInLocation.value);
    }

    if (value.outtimeLatitude != null && value.outtimeLongitude != null) {
      double latitude = double.tryParse(value.outtimeLatitude ?? "") ?? 0.0;
      double longitude = double.tryParse(value.outtimeLongitude ?? "") ?? 0.0;
      clockOutLocation.value = await LocationUtils.getAddressFromLatLng(
          latitude: latitude, longitude: longitude);
    }
  }
}
