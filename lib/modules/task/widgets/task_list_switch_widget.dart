import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';

class TaskListSwitchWidget extends GetView<TaskController> {
  const TaskListSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Spin(
          spins: 0.5,
          key: ValueKey(controller.taskListPageViewIndex.value),
          duration: Duration(milliseconds: 300),
          child: IconButton(
              onPressed: controller.onTaskListViewSwitchButtonClick,
              icon: Icon(getIconFromIndex(controller.taskListPageViewIndex.value))),
        ));
  }

  IconData getIconFromIndex(int index) {
    switch (index) {
      case 0:
        return Icons.grid_view_rounded;
      case 1:
        return Icons.view_agenda;
      case 2:
        return Icons.view_list_rounded;
      default:
        return Icons.help_outline;
    }
  }
}
