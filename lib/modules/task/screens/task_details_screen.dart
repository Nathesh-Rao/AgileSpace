import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/task/controllers/task_controller.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/widgets.dart';

class TaskDetailsScreen extends GetView<TaskController> {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskListModel taskModel = Get.arguments["taskModel"];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.loadTaskDetails(task: taskModel);
      await controller.getTaskRowOptions(taskModel.id);
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

      bottomNavigationBar: TaskDetailsBottomBarWidget(),
      floatingActionButton: FloatingActionButton(
        // mini: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 0,
        backgroundColor: Color(0xffCACED6),
        foregroundColor: AppColors.primaryTitleTextColorBlueGrey,
        onPressed: controller.toggleTaskDetailsRowOptions,
        child: Obx(() => _getFloatingIcon()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,

      // bottomNavigationBar: Obx(() => TaskDetailsBottomBarWidget()
      //     .skeletonLoading(controller.isTaskRowOptionsLoading.value)),
    );
  }

  _getFloatingIcon() {
    if (controller.isTaskRowOptionsLoading.value) {
      return CupertinoActivityIndicator(
        color: AppColors.primaryTitleTextColorBlueGrey,
      );
    }

    return !controller.isTaskDetailsRowOptionsExpanded.value
        ? Icon(CupertinoIcons.arrow_up_circle_fill)
        : Icon(CupertinoIcons.arrow_down_circle_fill);
  }
}
