import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/leaves/controller/leave_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../leaves.dart';

class LeaveDetailsHeaderWidget extends GetView<LeaveController> {
  const LeaveDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
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
          Spacer(),
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
                                sections: List.generate(controller.leaveDivisionsValue.length,
                                    (index) => _pieCrumbs(controller.leaveDivisionsValue[index])),
                              ),
                            ),
                            Text(
                              DateUtilsHelper.getShortMonthName(controller.leaveDetails.value?.date),
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
                        children: List.generate(controller.leaveDetails.value?.leaveBreakup.length ?? 0,
                            (index) => _breakTile(controller.leaveDetails.value!.leaveBreakup[index])),
                      ),
                    )),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              20.horizontalSpace,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Text(
                  "Apply for Leave",
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
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

  Widget _breakTile(LeaveBreakup leave) {
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
              leave.leaveNo.toString(),
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
