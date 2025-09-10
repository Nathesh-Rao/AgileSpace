import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets.dart';

class TaskDetailsLastActionWidget extends GetView<TaskController> {
  const TaskDetailsLastActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.taskHistoryList.isEmpty) {
        return SizedBox.shrink();
      }

      // if(controller.)

      var lastHistory = controller.taskHistoryList.value.last;

      if (lastHistory.message.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Color(0xffD9D9D9).withAlpha(20),
            border: Border.all(
              color: Color(0xffD9D9D9).withAlpha(100),
            )),
        width: double.infinity,
        child: Column(children: [
          Row(
            children: [
              20.horizontalSpace,
              Text(
                "Last action taken",
                style: AppStyles.taskHistoryUserNameStyle
                    .copyWith(fontSize: 10.sp),
              ),
              Spacer(),
              Text(
                lastHistory.fromUser.toUpperCase(),
                style: AppStyles.taskHistoryUserNameStyle,
              ),
              20.horizontalSpace,
            ],
          ),
          10.verticalSpace,
          Divider(
            color: Colors.grey.shade300,
            height: 1,
          ),
          10.verticalSpace,
          HistoryToolTipWidget(
            history: lastHistory,
          ),
        ]),
      );
    });
  }
}
