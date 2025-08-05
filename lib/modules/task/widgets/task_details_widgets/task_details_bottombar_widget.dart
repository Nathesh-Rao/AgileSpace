import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/flat_button_widget.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';

class TaskDetailsBottomBarWidget extends GetView<TaskController> {
  const TaskDetailsBottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: FlatButtonWidget(
              label: "Completed",
              onTap: () {},
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: FlatButtonWidget(
              color: AppColors.flatButtonColorPurple,
              label: "Reassign",
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
