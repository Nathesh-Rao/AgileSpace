import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:axpert_space/modules/news_events/controller/news_events_controller.dart';
import 'package:axpert_space/modules/web_view/controller/web_view_controller.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import 'package:axpert_space/modules/calendar/controller/calendar_controller.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:axpert_space/modules/settings/controller/settings_controller.dart';
import 'package:axpert_space/modules/task/task.dart';
import 'package:get/get.dart';
import '../../active_list/controller/active_list_details_controller.dart';
import '../../attendance/attendance.dart';
import '../../leaves/leaves.dart';
import '../../payroll/payroll.dart';
import '../../work_calendar/controller/work_calendar_controller.dart';
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
    Get.lazyPut<NewsEventsController>(() => NewsEventsController());
    Get.lazyPut<WorkCalendarController>(() => WorkCalendarController());
    Get.put<ActiveListController>(ActiveListController(), permanent: true);
    Get.put<ActiveListDetailsController>(ActiveListDetailsController(),
        permanent: true);
  }
}
