import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';
import 'task_list_switch_widget.dart';

class TaskSearchActionWidget extends GetView<TaskController> {
  const TaskSearchActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PrimarySearchFieldWidget(
          onChanged: controller.onTaskSearch,
          onSuffixTap: () => controller.onTaskSearch(""),
        ),
        10.horizontalSpace,
        IconButton(
            onPressed: () {
              if (controller.taskFilterExpandController.isExpanded) {
                controller.taskFilterExpandController.collapse();
              } else {
                controller.taskFilterExpandController.expand();
              }
            },
            icon: Image.asset(
              "assets/icons/common/filters-2.png",
              width: 24.w,
            )),
        TaskListSwitchWidget(),
        10.horizontalSpace,
      ],
    );
  }
}
