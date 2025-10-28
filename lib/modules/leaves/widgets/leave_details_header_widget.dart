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
        color: AppColors.baseGray.withAlpha(150),
        // color: AppColors.snackBarNotificationColorBlue.withAlpha(100),

        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color(0xFF3334A0),
        //     Color(0xFF12133A),
        //   ],
        // ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Row(
            children: [
              20.horizontalSpace,
              Text(
                DateUtilsHelper.getTodayFormattedDate(),
                style: AppStyles.actionButtonStyle
                    .copyWith(color: AppColors.blue10),
              ),
            ],
          ),
          Spacer(),
          Container(
            height: 125.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.secondaryButtonBGColorWhite,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.r),
                topLeft: Radius.circular(100.r),
                bottomRight: Radius.circular(10.r),
                bottomLeft: Radius.circular(100.r),
              ),
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
                                sections: List.generate(
                                    controller.leaveDivisionsValue.length,
                                    (index) => _pieCrumbs(index)),
                              ),
                            ),
                            Text(
                              DateUtilsHelper.getShortMonthName(
                                  DateTime.now().toString()),
                              style: AppStyles.actionButtonStyle,
                            )
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Wrap(
                        spacing: 20.w,
                        runSpacing: 20.w,
                        children: List.generate(
                            controller.leaveDetailsList.length,
                            (index) => _breakTile(index)),
                      ),
                    )),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              20.horizontalSpace,
              InkWell(
                onTap: () {
                  Get.back();
                  controller.applyForLeave();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: Colors.white,
                    // AppColors.snackBarNotificationColorBlue.withAlpha(150),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  child: Text(
                    "Apply for Leave",
                    style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue10),
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

  PieChartSectionData _pieCrumbs(int index) {
    double value = controller.leaveDivisionsValue[index];
    Color color = controller.getColorList()[index];
    return PieChartSectionData(
      color: color,
      value: value,
      showTitle: false,
      radius: 20,
    );
  }

  Widget _breakTile(int index) {
    LeaveDetailsModel leave = controller.leaveDetailsList[index];
    Color color = controller.getColorList()[index];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.w,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.circle,
            size: 12.sp,
            color: color,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leave.leaveType.split(" ")[0],
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
            RichText(
              text: TextSpan(
                  text: (leave.totalLeaves - leave.leavesTaken)
                      .toInt()
                      .toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: AppColors.primaryActionColorDarkBlue,
                    // color: color,
                  ),
                  children: [
                    TextSpan(
                      text: "  ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 7.sp,
                        color: AppColors.text2,
                      ),
                      children: [
                        TextSpan(
                          text: "(${leave.totalLeaves.toInt().toString()})",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 9.sp,
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ]),
            )
          ],
        ),
      ],
    );
  }
}
