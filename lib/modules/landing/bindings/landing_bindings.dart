import 'package:axpert_space/common/controller/web_view_controller.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import 'package:axpert_space/modules/calendar/controller/calendar_controller.dart';
import 'package:axpert_space/modules/settings/controller/settings_controller.dart';
import 'package:axpert_space/modules/task/task.dart';
import 'package:get/get.dart';
import '../../attendance/attendance.dart';
import '../../leaves/leaves.dart';
import '../../payroll/payroll.dart';
import '../controllers/landing_controller.dart';

class LandingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(() => LandingController());
    Get.lazyPut<AttendanceController>(() => AttendanceController());
    Get.lazyPut<TaskController>(() => TaskController());
    Get.lazyPut<LeaveController>(() => LeaveController());
    Get.lazyPut<PayRollController>(() => PayRollController());
    Get.lazyPut<CalendarController>(() => CalendarController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<WebViewController>(() => WebViewController());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
