import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/payroll/models/payroll_overview_model.dart';
import 'package:axpert_space/modules/payroll/payroll.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/colors/app_colors.dart';
import '../../../core/core.dart';
import '../../../core/utils/date_utils.dart';

class PayrollDetailsHeaderWidget extends GetView<PayRollController> {
  const PayrollDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 335.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3334A0),
            Color(0xFF12133A),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 10.w, bottom: 15.h),
            child: Row(
              children: [
                Text(
                  "Net Pay",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          // Spacer(),
          Obx(
            () => Row(
              children: [
                20.horizontalSpace,
                Text(
                  controller.isAmountVisible.value
                      ? "₹${controller.payRollOverview.value?.totalAmount.toString()}"
                      : StringUtils.maskAmount("₹${controller.payRollOverview.value?.totalAmount.toString() ?? "*****"}"),
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Obx(
                  () => GestureDetector(
                    onTap: controller.isAmountVisible.toggle,
                    child: Icon(
                      controller.isAmountVisible.value ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white30,
                    ),
                  ),
                ),
                20.horizontalSpace,
              ],
            ),
          ),
          10.verticalSpace,
          Row(
            children: [
              20.horizontalSpace,
              Text(
                "June 25",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: 125.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 30.h,
                                sections: List.generate(controller.payDivisionsValue.length,
                                    (index) => _pieCrumbs(controller.payDivisionsValue[index])),
                              ),
                            ),
                            Text(
                              DateUtilsHelper.getShortMonthName(controller.payRollOverview.value?.date),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Wrap(
                        spacing: 20.w,
                        runSpacing: 20.w,
                        children: List.generate(controller.payRollOverview.value?.payBreakup.length ?? 0,
                            (index) => _breakTile(controller.payRollOverview.value!.payBreakup[index])),
                      ),
                    )),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              20.horizontalSpace,
              _actionButton(label: "Payslip", icon: Icons.download),
              20.horizontalSpace,
              _actionButton(label: "Form 16", icon: Icons.download),
              20.horizontalSpace,
              _actionButton(label: "{action}", icon: Icons.download),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _actionButton({required String label, required IconData icon}) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.w,
          children: [
            Icon(
              icon,
              size: 15,
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  PieChartSectionData _pieCrumbs(double value) {
    return PieChartSectionData(
      color: AppColors.getNextColor(),
      value: value,
      showTitle: false,
      radius: 20,
    );
  }

  Widget _breakTile(PayBreakup leave) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.w,
      children: [
        Icon(
          Icons.circle,
          size: 16.w,
          color: Color(0xff0271F2),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leave.name.split(" ")[0],
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10.sp,
              ),
            ),
            Text(
              leave.amount.toString(),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
