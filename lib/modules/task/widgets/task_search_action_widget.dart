import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/attendance/controllers/attendance_controller.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../common/common.dart';
import 'task_list_switch_widget.dart';

class TaskSearchActionWidget extends GetView<TaskController> {
  const TaskSearchActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AttendanceController attendanceController = Get.find();
    return Row(
      children: [
        PrimarySearchFieldWidget(
          controller: controller.searchController,
          onChanged: controller.onTaskSearch,
          onSuffixTap: () {
            controller.onTaskSearch("");
          },
        ),
        10.horizontalSpace,
        // IconButton(
        //     onPressed: () {
        //       if (controller.taskFilterExpandController.isExpanded) {
        //         controller.taskFilterExpandController.collapse();
        //       } else {
        //         controller.taskFilterExpandController.expand();
        //       }
        //     },
        //     icon: Image.asset(
        //       "assets/icons/common/filters-2.png",
        //       width: 24.w,
        //     )),
        Obx(
          () {
            var isLoading = (controller.isTaskListLoading.value ||
                attendanceController.isAttendanceDetailsIsLoading.value);

            var color = attendanceController.isAttendanceDetailsIsLoading.value
                ? AppColors.leaveWidgetColorGreen
                : AppColors.baseYellow;

            return Spin(
              infinite: true,
              curve: Curves.ease,
              animate: isLoading,
              duration: Duration(milliseconds: 800),
              child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: isLoading
                        ? WidgetStatePropertyAll(color.withAlpha(50))
                        : null,
                  ),
                  onLongPress: () {
                    attendanceController.getInitialAttendanceDetails(
                        force: true);
                    controller.loadInitialData(force: true);
                  },
                  onPressed: () async {
                    attendanceController.getInitialAttendanceDetails(
                        force: true);
                    controller.getTaskWithFilter();
                  },
                  // icon: Icon(
                  //   CupertinoIcons.refresh_circled,
                  //   color: color,
                  // ),

                  icon: Image.asset(
                    "assets/icons/common/sync.png",
                    width: 23.w,
                    color: color,
                  )),
            );
          },
        ),
        TaskListSwitchWidget(),
        10.horizontalSpace,
      ],
    );
  }
}
