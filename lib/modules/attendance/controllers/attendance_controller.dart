import 'package:axpert_space/modules/attendance/models/AttendanceReportModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';

class AttendanceController extends GetxController {
  var attendanceAppbarSwitchValue = false.obs;
  var attendanceAppbarSwitchIsLoading = false.obs;
  var attendanceClockInWidgetCallBackValue = false.obs;
//----
  var attendanceDashboardIsLoading = false.obs;
  var attendanceState = AttendanceState.notPunchedIn.obs;
//-----
  var attendanceReportList = [].obs;
  var isAttendanceReportLoading = false.obs;
  var isLogExpanded = false.obs;
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

  var selectedMonthIndex = 11.obs;
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
    isLogExpanded.value = false;
    if (attendanceReportList.isEmpty) {
      _getAttendanceReport();
    }
  }

  switchLogExpandValue() {
    isLogExpanded.toggle();
  }

  _getAttendanceReport() async {
    isAttendanceReportLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    attendanceReportList.value = AttendanceReportModel.sampleData;
    isAttendanceReportLoading.value = false;
  }

  onAttendanceAppbarSwitch(bool val) async {
    attendanceAppbarSwitchIsLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    attendanceAppbarSwitchIsLoading.value = false;
    attendanceClockInWidgetCallBackValue.value = true;
    attendanceAppbarSwitchValue.value = !attendanceAppbarSwitchValue.value;
  }

  onAttendanceClockInCardClick() async {
    attendanceAppbarSwitchIsLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    attendanceAppbarSwitchIsLoading.value = false;
    attendanceClockInWidgetCallBackValue.value = true;
    attendanceAppbarSwitchValue.value = !attendanceAppbarSwitchValue.value;
  }

  onAttendanceClockInAnimationEnd() {
    attendanceClockInWidgetCallBackValue.value = false;
  }

  //--------
  setAttendanceDashboard() {}
}
