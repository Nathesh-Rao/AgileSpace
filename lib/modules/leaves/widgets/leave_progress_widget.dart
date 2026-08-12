import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/leaves/leaves.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';

class LeaveProgressWidget extends GetView<LeaveController> {
  const LeaveProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Stack(
      children: [
        SizedBox(
          height: 100.h,
          width: 100.h,
          child: CircularProgressIndicator(
            strokeWidth: 7,
            value: 1,
            // strokeCap: StrokeCap.round,
            color: controller
                .getLeaveProgressColor(controller.leaveCountRatio.value)
                .withAlpha(70),
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: controller.leaveCountRatio.value),
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate,
          builder: (context, value, child) {
            return SizedBox(
              height: 100.h,
              width: 100.h,
              child: CircularProgressIndicator(
                strokeWidth: 7,
                value: value,
                strokeCap: StrokeCap.round,
                color: controller
                    .getLeaveProgressColor(controller.leaveCountRatio.value),
              ),
            );
          },
        ),
        SizedBox(
          height: 100.h,
          width: 100.h,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${controller.totalLeaveRemainingCount}",
                  style: AppStyles.leaveActivityMainStyle,
                ),
                Text(
                  "Leave balance",
                  style:
                      AppStyles.leaveActivityMainStyle.copyWith(fontSize: 7.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    )));
  }
}
