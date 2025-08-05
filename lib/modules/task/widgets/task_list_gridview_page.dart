import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/utils/extensions.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_list_gridtile_widget.dart';

class TaskListGridviewPage extends GetView<TaskController> {
  const TaskListGridviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: controller.isTaskListLoading.value ? 20 : controller.taskList.length,
        itemBuilder: (context, index) {
          return TaskListGridTileWidget(
            taskModel: controller.taskList[index],
          ).skeletonLoading(controller.isTaskListLoading.value);
        },
      ),
    );
  }
}
