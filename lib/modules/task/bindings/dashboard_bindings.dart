import 'package:get/get.dart';

import '../controllers/task_controller.dart';

class TaskBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController());
  }
}
