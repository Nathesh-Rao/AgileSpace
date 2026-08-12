import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';

class TaskDetailsHistoryHorizontalListWidget extends GetView<TaskController> {
  const TaskDetailsHistoryHorizontalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        // shrinkWrap: true,
        padding: EdgeInsets.all(15),
        itemCount: controller.taskHistoryList.length,
        scrollDirection: Axis.horizontal,

        // scrollDirection: controller.showHistoryContent.value ? Axis.vertical : Axis.horizontal,
        separatorBuilder: (context, index) {
          var history = controller.taskHistoryList[index];
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/icons/common/arrow_line_icon.png",
                color: AppColors.getHistoryColor(history.status),
                width: 95.w,
              ),
              5.horizontalSpace,
            ],
          );
        },
        itemBuilder: (context, index) {
          var history = controller.taskHistoryList[index];

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 10.w,
                backgroundColor: AppColors.getHistoryColor(history.status),
                child: Text(
                  "${index + 1}",
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              5.horizontalSpace,
              Text(
                controller.taskHistoryList[index].username,
                style: AppStyles.taskHistoryUserNameStyle,
              ),
              5.horizontalSpace,
            ],
          );
        });
  }
}
