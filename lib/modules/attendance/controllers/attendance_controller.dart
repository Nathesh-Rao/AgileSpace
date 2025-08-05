import 'package:get/get.dart';

class AttendanceController extends GetxController {
  var attendanceAppbarSwitchValue = false.obs;
  var attendanceAppbarSwitchIsLoading = false.obs;
  var attendanceClockInWidgetCallBackValue = false.obs;

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
}
