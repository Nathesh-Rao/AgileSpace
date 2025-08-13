import 'package:axpert_space/modules/task/task.dart';
import 'package:get/get.dart';
import '../../attendance/attendance.dart';
import '../../leaves/leaves.dart';
import '../controllers/landing_controller.dart';

class LandingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(() => LandingController());
    Get.lazyPut<AttendanceController>(() => AttendanceController());
    Get.lazyPut<TaskController>(() => TaskController());
    Get.lazyPut<LeaveController>(() => LeaveController());
  }
}
