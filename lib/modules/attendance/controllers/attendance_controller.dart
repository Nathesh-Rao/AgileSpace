import 'dart:convert';

import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:axpert_space/data/data_source/datasource_services.dart';
import 'package:axpert_space/modules/attendance/models/AttendanceReportModel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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
      "datasource": DataSourceServices.DS_GETATTENDANCELOG,
      "sqlParams": {
        "username": globalVariableController.NICK_NAME.value,
        "month": "${DateTime.now().year}-$selectedMonthIndex"
      }
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
      "datasource": DataSourceServices.DS_GETATTENDANCE_DETAIL,
      "sqlParams": {
        "username": globalVariableController.USER_NAME.value,
        "date": DateFormat('dd-MM-yyyy').format(DateTime.now())
      }
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));
    // LogService.writeLog(message: dsResp);
    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        if (jsonDSResp['result']['data'].isEmpty) {
          isAttendanceDetailsIsLoading.value = false;
          return;
        }

        var dsData = jsonDSResp['result']['data'][0] ?? '';

        // var beforePunchIn = {
        //   "username": "amrithanath",
        //   "status": "notPunchedIn",
        //   "actual_intime": "9:30 AM",
        //   "intime": null,
        //   "actual_outtime": "6:30 PM",
        //   "outtime": null,
        //   "intime_latitude": null,
        //   "intime_longitude": null,
        //   "outtime_latitude": null,
        //   "outtime_longitude": null,
        //   "worksheet_update_status": "Not Filled"
        // };

        // var punchedIn = {
        //   "username": "amrithanath",
        //   "status": "punchedIn",
        //   "actual_intime": "9:30 AM",
        //   "intime": "09:31:52",
        //   "actual_outtime": "6:30 PM",
        //   "outtime": null,
        //   "intime_latitude": "12.9716",
        //   "intime_longitude": "77.5946",
        //   "outtime_latitude": null,
        //   "outtime_longitude": null,
        //   "worksheet_update_status": "Not Filled"
        // };

        // var punchedOut = {
        //   "username": "amrithanath",
        //   "status": "punchedOut",
        //   "actual_intime": "9:30 AM",
        //   "intime": "09:31:52",
        //   "actual_outtime": "6:30 PM",
        //   "outtime": "18:31:05",
        //   "intime_latitude": "12.9716",
        //   "intime_longitude": "77.5946",
        //   "outtime_latitude": "12.9720",
        //   "outtime_longitude": "77.5950",
        //   "worksheet_update_status": "Filled"
        // };

        try {
          LogService.writeLog(message: dsData.toString());
          attendanceDetails.value = AttendanceDetailsModel.fromJson(dsData);
          if (attendanceDetails.value != null) {
            await _setAttendanceStatus(attendanceDetails.value!);
          } else {
            attendanceState.value = AttendanceState.error;
          }
        } catch (e) {
          isAttendanceDetailsIsLoading.value = false;
          LogService.writeLog(message: "$e");
        }
      }
    }

    isAttendanceDetailsIsLoading.value = false;
  }

  String clockedInTimeStatus(String timeStr, String expectedTimeStr) {
    try {
      DateTime now = DateTime.now();

      DateTime expected = _parseTime(expectedTimeStr, now);

      DateTime actual = _parseTime(timeStr, now);

      Duration diff = actual.difference(expected);

      if (diff.inMinutes >= 5) {
        return "On time";
      } else if (diff.isNegative) {
        Duration early = expected.difference(actual);
        int hours = early.inHours;
        int minutes = early.inMinutes.remainder(60);
        return hours > 0
            ? "Early by $hours hr $minutes min"
            : "Early by $minutes min";
      } else {
        int hours = diff.inHours;
        int minutes = diff.inMinutes.remainder(60);
        return hours > 0
            ? "Late by $hours hr $minutes min"
            : "Late by $minutes min";
      }
    } catch (e) {
      return "Invalid time format: '$timeStr'";
    }
  }

  DateTime _parseTime(String timeStr, DateTime refDate) {
    String input = timeStr.trim().toUpperCase();

    List<String> parts = input.split(' ');
    if (parts.length != 2) throw FormatException("Invalid time format");

    String timePart = parts[0];
    String ampm = parts[1];

    List<String> hm = timePart.split(':');
    if (hm.length != 2) throw FormatException("Invalid time format");

    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);

    if (ampm == "PM" && hour != 12) hour += 12;
    if (ampm == "AM" && hour == 12) hour = 0;

    return DateTime(refDate.year, refDate.month, refDate.day, hour, minute);
  }

  String clockTimeStatus(String timeStr) {
    try {
      String input = timeStr.trim().toUpperCase();

      List<String> parts = input.split(' ');
      if (parts.length != 2) return "Invalid time format";

      String timePart = parts[0];
      String ampm = parts[1];

      List<String> hm = timePart.split(':');
      if (hm.length != 2) return "Invalid time format";

      int hour = int.parse(hm[0]);
      int minute = int.parse(hm[1]);

      if (ampm == "PM" && hour != 12) hour += 12;
      if (ampm == "AM" && hour == 12) hour = 0;

      DateTime now = DateTime.now();
      DateTime targetTime =
          DateTime(now.year, now.month, now.day, hour, minute);

      bool isClockIn = targetTime.hour < 12;

      Duration diff = targetTime.difference(now);

      if (isClockIn) {
        if (diff.inSeconds > 0) {
          int hours = diff.inHours;
          int minutes = diff.inMinutes.remainder(60);
          return hours > 0
              ? "$hours hr $minutes min remaining to clock in"
              : "$minutes min remaining to clock in";
        } else {
          Duration late = now.difference(targetTime);
          int hours = late.inHours;
          int minutes = late.inMinutes.remainder(60);
          return hours > 0
              ? "Late by $hours hr $minutes min"
              : "Late by $minutes min";
        }
      } else {
        if (diff.inSeconds > 0) {
          int hours = diff.inHours;
          int minutes = diff.inMinutes.remainder(60);
          return hours > 0
              ? "Eligible to clock out in $hours hr $minutes min"
              : "Eligible to clock out in $minutes min";
        } else {
          Duration overtime = now.difference(targetTime);
          int hours = overtime.inHours;
          int minutes = overtime.inMinutes.remainder(60);
          return hours > 0
              ? "Clocked out $hours hr $minutes min ago"
              : "Clocked out $minutes min ago";
        }
      }
    } catch (e) {
      return "Invalid time format: '$timeStr'";
    }
  }

  _setAttendanceStatus(AttendanceDetailsModel attendance) async {
    if (attendance.intime == null && attendance.outtime == null) {
      attendanceState.value = AttendanceState.notPunchedIn;
    } else if (attendance.intime != null && attendance.outtime == null) {
      attendanceState.value = AttendanceState.punchedIn;
    } else if (attendance.intime != null && attendance.outtime != null) {
      attendanceState.value = AttendanceState.punchedOut;
    } else {
      attendanceState.value = AttendanceState.error;
    }
    LogService.writeLog(
        message: "Punch status : ${attendanceState.value.name}");
    await _setLocationDetails(attendance);
  }

  _setLocationDetails(AttendanceDetailsModel value) async {
    if (attendanceState.value == AttendanceState.notPunchedIn ||
        attendanceState.value == AttendanceState.punchedIn) {
      await getCurrentAddress();
    } else {
      if (value.intimeLatitude != null && value.intimeLongitude != null) {
        double latitude = double.tryParse(value.intimeLatitude ?? "") ?? 0.0;
        double longitude = double.tryParse(value.intimeLongitude ?? "") ?? 0.0;

        clockInLocation.value = extractAddress(
            await LocationUtils.getAddressFromLatLng(
                latitude: latitude, longitude: longitude));

        LogService.writeLog(message: clockInLocation.value);
      }

      if (value.outtimeLatitude != null && value.outtimeLongitude != null) {
        double latitude = double.tryParse(value.outtimeLatitude ?? "") ?? 0.0;
        double longitude = double.tryParse(value.outtimeLongitude ?? "") ?? 0.0;
        clockOutLocation.value = extractAddress(
            await LocationUtils.getAddressFromLatLng(
                latitude: latitude, longitude: longitude));
      }
    }
    LogService.writeLog(message: "position : ${clockInLocation.value}");
  }

  getCurrentAddress() async {
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      clockOutLocation.value =
          clockInLocation.value = 'Enable location permissions';
    } else {
      var position = await Geolocator.getCurrentPosition();

      clockOutLocation.value = clockInLocation.value = extractAddress(
          await LocationUtils.getAddressFromLatLng(
              latitude: position.latitude, longitude: position.longitude));
    }
  }

  String extractAddress(String input) {
    try {
      Map<String, String> fields = {};
      List<String> lines = input.split(",");
      for (String line in lines) {
        List<String> parts = line.split(":");
        if (parts.length == 2) {
          String key = parts[0].trim();
          String value = parts[1].trim();
          fields[key] = value;
        }
      }

      String name = fields["Name"] ?? "";
      String street = fields["Street"] ?? "";
      String locality = fields["Locality"] ?? "";
      String area = fields["Administrative area"] ?? "";

      // Join only non-empty values with commas
      return [name, street, locality, area]
          .where((v) => v.isNotEmpty)
          .join(", ");
    } catch (e) {
      return "Invalid input";
    }
  }
}
