import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../task.dart';
import 'task_list_listtile_widget.dart';

class TaskListListviewPage extends GetView<TaskController> {
  const TaskListListviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemCount: controller.taskList.length,
          itemBuilder: (context, index) =>
              TaskListListTileWidget(taskModel: controller.taskList[index]).skeletonLoading(controller.isTaskListLoading.value)),
    );
  }
}
