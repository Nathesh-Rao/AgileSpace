import 'package:axpert_space/modules/payroll/models/payroll_overview_model.dart';
import 'package:axpert_space/modules/payroll/payroll.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../core/core.dart';

class PayRollDashBoardWidget extends GetView<PayRollController> {
  const PayRollDashBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPayrollOverviewDetails();
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconLabelWidget(iconColor: Colors.blue, label: "Payslip"),
        10.verticalSpace,
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.payRollDetails);
          },
          child: Container(
            width: double.infinity,
            height: 202.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.secondaryButtonBorderColorGrey,
                )),
            child: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    left: 110.w,
                    child: Image.asset(
                      "assets/images/common/reciept.png",
                      width: 80.w,
                    )),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(top: 14.w, bottom: 14.w, left: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Net Pay",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            controller.isAmountVisible.value
                                ? "₹${controller.payRollOverview.value?.totalAmount.toString()}"
                                : StringUtils.maskAmount(
                                    "₹${controller.payRollOverview.value?.totalAmount.toString() ?? "*****"}"),
                            style: GoogleFonts.poppins(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff282D46),
                            ),
                          ),
                          15.verticalSpace,
                          Expanded(
                              child: ListView(
                            // padding: EdgeInsets.symmetric(vertical: 15.h),
                            children: List.generate(controller.payRollOverview.value?.payBreakup.length ?? 0,
                                (index) => _breakTile(controller.payRollOverview.value!.payBreakup[index])),
                          )),
                          15.verticalSpace,
                          Text(
                            "Get Payslip",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: SizedBox(
                      child: Obx(
                        () => SizedBox(
                          height: 145.h,
                          width: 145.h,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 5,
                                  centerSpaceRadius: 50.h,
                                  startDegreeOffset: 10,
                                  sections: List.generate(controller.payDivisionsValue.length,
                                      (index) => _pieCrumbs(controller.payDivisionsValue[index])),
                                ),
                              ),
                              Text(
                                DateUtilsHelper.getShortMonthName(controller.payRollOverview.value?.date),
                                style: GoogleFonts.poppins(
                                  // color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  PieChartSectionData _pieCrumbs(double value) {
    return PieChartSectionData(
      color: AppColors.getNextColor(),
      value: value,
      showTitle: false,
      radius: 20,
    );
  }

  Widget _breakTile(PayBreakup leave) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.w,
        children: [
          Icon(
            Icons.circle,
            size: 10.w,
            color: Color(0xff0271F2),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leave.name.split(" ")[0],
                style: GoogleFonts.poppins(
                  // color: Colors.white,
                  fontWeight: FontWeight.w500,

                  fontSize: 10.sp,
                ),
              ),
              Text(
                leave.amount.toString(),
                style: GoogleFonts.poppins(
                  // color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
