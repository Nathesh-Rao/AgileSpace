import 'package:axpert_space/modules/payroll/payroll.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../core/core.dart';

class PayRollDashBoardWidget extends GetView<PayRollController> {
  const PayRollDashBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconLabelWidget(iconColor: Colors.blue, label: "Payslip"),
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
