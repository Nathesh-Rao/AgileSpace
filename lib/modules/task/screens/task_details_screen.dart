import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/task/controllers/task_controller.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/widgets.dart';

class TaskDetailsScreen extends GetView<TaskController> {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskListModel taskModel = Get.arguments["taskModel"];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadTaskDetails(task: taskModel);
    });
    // var max1 = 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("TID : ${taskModel.id}"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(AntDesign.edit_fill))
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: controller.onTaskDetailsPullUpDownCallBack,
        child: ListView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: [
            TaskDetailsHistoryWidget(),
            Obx(() => TaskDetailsTaskInfoWidget(taskModel: taskModel)
                .skeletonLoading(controller.isTaskDetailsLoading.value)),
            Obx(() => TaskDetailsAttachmentsWidget(taskModel: taskModel)
                .skeletonLoading(controller.isTaskDetailsLoading.value)),
            13.verticalSpace,
            Obx(() => TaskDetailsCommentsWidget()
                .skeletonLoading(controller.isTaskDetailsLoading.value)),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => TaskDetailsBottomBarWidget()
          .skeletonLoading(controller.isTaskDetailsLoading.value)),
    );
  }
}
