import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/payroll/payroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';

class PayRollAppBarTitleWidget extends GetView<PayRollController> {
  const PayRollAppBarTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.verticalSpace,
        Text(
          "Track your Time & Pay 📋",
          style: AppStyles.appBarTitleTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryActionColorDarkBlue,
            fontSize: 16.sp,
          ),
        ),
        3.verticalSpace,
        Text(
          "Payroll - Attendance - Leaves",
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
