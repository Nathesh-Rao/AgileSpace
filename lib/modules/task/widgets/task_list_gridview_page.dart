import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/utils/extensions.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/models.dart';
import 'task_list_gridtile_widget.dart';

class TaskListGridviewPage extends GetView<TaskController> {
  const TaskListGridviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.taskList.isEmpty && controller.isTaskListLoading.value)
          ? _gridViewWrapper(
              itemCount: TaskListModel.tempList.length,
              itemBuilder: (context, index) {
                return TaskListGridTileWidget(
                  taskModel: TaskListModel.tempList[index],
                ).skeletonLoading(true);
              })
          : _gridViewWrapper(
              itemCount: controller.taskList.length,
              itemBuilder: (context, index) {
                return Obx(
                  () => TaskListGridTileWidget(
                    taskModel: controller.taskList[index],
                  ).skeletonLoading(controller.isTaskListLoading.value),
                );
              },
            ),
    );
  }

  _gridViewWrapper(
      {required int itemCount,
      required Widget? Function(BuildContext, int) itemBuilder}) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 100.h),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
