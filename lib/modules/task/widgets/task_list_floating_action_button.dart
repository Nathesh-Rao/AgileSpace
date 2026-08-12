import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../web_view/controller/web_view_controller.dart';

class TaskListFloatingActionButton extends GetView<TaskController> {
  const TaskListFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        // label: Text(
        //   "Create Task",
        //   style: AppStyles.searchFieldTextStyle.copyWith(
        //     color: AppColors.primaryButtonFGColorWhite,
        //   ),
        // ),
        backgroundColor: AppColors.chipCardWidgetColorBlue,
        foregroundColor: AppColors.primaryButtonFGColorWhite,
        child: Icon(CupertinoIcons.create),
        onPressed: () {
          controller.navigateToCreateTask();
        });
  }
}
