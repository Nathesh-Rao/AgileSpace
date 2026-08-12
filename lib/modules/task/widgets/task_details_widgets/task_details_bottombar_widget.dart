import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/flat_button_widget.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/task_row_options_model.dart';

class TaskDetailsBottomBarWidget extends GetView<TaskController> {
  const TaskDetailsBottomBarWidget({super.key, required this.taskID});
  final String taskID;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        height: controller.isTaskDetailsRowOptionsExpanded.value
            ? _getHeight()
            : 80.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
          ],
        ),
        child: Obx(
          () {
            var actionList = List.generate(controller.taskRowOptions.length,
                (index) => _rowTile(controller.taskRowOptions[index]));

            if (actionList.length.isOdd) {
              actionList.add(((1.sw / 2) - 30.w).horizontalSpace);
            }

            return Wrap(
              alignment: WrapAlignment.spaceAround,
              runAlignment: WrapAlignment.start,
              spacing: 10.w,
              runSpacing: 15.h,
              children: actionList,
            ).skeletonLoading(controller.isTaskRowOptionsLoading.value);
          },
        ),
      ),
    );
  }

  double _getHeight() {
    var length = controller.taskRowOptions.length;

    if (length == 0) return 50.h;

    int multiplier = (length / 2).ceil();
    return (multiplier * 80).h;
  }

  Widget _rowTile(TaskRowOptionModel taskRowOption) {
    return FlatButtonWidget(
      width: (1.sw / 2) - 30.w,
      label: taskRowOption.url.split(",")[1],
      // label: taskRowOption.url,

      color: controller.getTaskActionColor(taskRowOption.action),
      onTap: () {
        Get.back();
        controller.acceptTaskTemp(taskRowOption, taskID);
      },
      // isCompact: true,
    );
  }
}
