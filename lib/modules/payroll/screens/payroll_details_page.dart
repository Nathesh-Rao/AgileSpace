import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/payroll/models/payroll_history_model.dart';
import 'package:axpert_space/modules/payroll/payroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/colors/app_colors.dart';
import '../widgets/payroll_details_header_widget.dart';

class PayrollDetailsPage extends GetView<PayRollController> {
  const PayrollDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Payroll",
        ),
      ),
      body: Column(
        children: [
          Obx(() => (controller.payRollOverview.value == null && controller.payrollOverviewLoading.value) ||
                  (controller.payRollOverview.value != null)
              ? PayrollDetailsHeaderWidget()
                  .skeletonLoading((controller.payRollOverview.value == null) ? true : controller.payrollOverviewLoading.value)
              : SizedBox.shrink()),
          10.verticalSpace,
          Row(
            children: [
              23.horizontalSpace,
              IconLabelWidget(iconColor: AppColors.violetBorder, label: "Previous Payslips"),
            ],
          ),
          5.verticalSpace,
          Expanded(
              child: Obx(
            () => ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    itemCount: controller.payrollHistoryList.value.length,
                    itemBuilder: (context, index) => _historyTile(controller.payrollHistoryList[index]))
                .skeletonLoading(controller.payrollOverviewLoading.value),
          ))
        ],
      ),
    );
  }

  _historyTile(PayrollHistoryModel payroll) {
    return ListTile(
      leading: Image.asset(
        "assets/images/common/download.png",
        width: 40.w,
      ),
      title: Text(
        // "${payroll.name} - ${payroll.date}days",
        payroll.name,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
      subtitle: Text(
        "${DateUtilsHelper.getShortDayName(payroll.date)} ${DateUtilsHelper.getDateNumber(payroll.date)}-${DateUtilsHelper.getShortMonthName(payroll.date)}",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
        ),
      ),
      trailing: Text("₹${StringUtils.maskAmount(payroll.totalAmount.toString())}",
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
