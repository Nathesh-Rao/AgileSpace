import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../task.dart';
import 'widgets.dart';

class TaskListSingleViewPage extends GetView<TaskController> {
  const TaskListSingleViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemCount: controller.taskList.length,
          itemBuilder: (context, index) => Skeletonizer(
              enabled: controller.isTaskListLoading.value,
              child: TaskListSingleTileWidget(taskModel: controller.taskList[index]))),
    );
  }
}
