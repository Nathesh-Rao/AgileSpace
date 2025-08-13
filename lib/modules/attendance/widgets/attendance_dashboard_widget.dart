import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../core/core.dart';
import '../attendance.dart';

class AttendanceDashBoardWidget extends GetView<AttendanceController> {
  const AttendanceDashBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconLabelWidget(iconColor: Color(0xff8371EC), label: "Attendance"),
        10.verticalSpace,
        Container(
          width: double.infinity,
          height: 202.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.secondaryButtonBorderColorGrey,
              )),
        )
      ],
    );
  }
}
