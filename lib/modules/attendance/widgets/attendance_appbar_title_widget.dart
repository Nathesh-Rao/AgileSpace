import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/attendance/attendance.dart';
import 'package:axpert_space/modules/task/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';

class AttendanceAppBarTitleWidget extends GetView<AttendanceController> {
  const AttendanceAppBarTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.verticalSpace,
        RichText(
          text: TextSpan(
            text: 'Hey, ',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              color: AppColors.primaryActionColorDarkBlue,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: 'Tonald Drump 👋🏻',
                style: AppStyles.appBarTitleTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryActionColorDarkBlue,
                ),
              ),
            ],
          ),
        ),
        3.verticalSpace,
        TaskOverviewCountWidget(),
      ],
    );
  }
}
