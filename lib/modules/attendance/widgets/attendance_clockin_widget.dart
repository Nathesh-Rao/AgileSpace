import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../attendance.dart';

class AttendanceClockInWidget extends GetView<AttendanceController> {
  const AttendanceClockInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        height: !controller.attendanceAppbarSwitchValue.value ? 106.h : 60.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: AppColors.taskClockInWidgetColorPurple,
        ),
        onEnd: controller.onAttendanceClockInAnimationEnd,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                children: [
                  20.horizontalSpace,
                  Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 10.h,
                  ),
                  5.horizontalSpace,
                  Text(
                    "Axpert-house, Jayanagar Bangalore",
                    style: GoogleFonts.poppins(
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.white,
                  ),
                  child: !controller.attendanceClockInWidgetCallBackValue.value
                      ? _getWidget()
                      : SizedBox.expand(
                          key: ValueKey(controller.attendanceClockInWidgetCallBackValue.value),
                        )),
            ),
          ],
        ),
      ),
    );
  }

  _getWidget() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: !controller.attendanceAppbarSwitchValue.value ? _clockedInWidget() : _clockedOutWidget(),
    );
  }

  Widget _clockedInWidget() => Row(
        children: [
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                  key: ValueKey(controller.attendanceAppbarSwitchValue.value),
                  text: TextSpan(text: "09:16 am", style: AppStyles.attendanceWidgetTimeStyle)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    // CupertinoIcons.check_mark_circled_solid,
                    Icons.check_circle,
                    color: AppColors.otpFieldThemeColorGreen,
                    size: 12.h,
                  ),
                  5.horizontalSpace,
                  Text(
                    "Work Sheet Updated",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          )),
          Expanded(
              child: PrimaryButtonWidget(
            key: ValueKey(controller.attendanceAppbarSwitchValue.value),
            isLoading: controller.attendanceAppbarSwitchIsLoading.value,
            onPressed: controller.onAttendanceClockInCardClick,
            label: "ClockInn 🌞",
            backgroundColor: AppColors.taskClockInWidgetColorPurple,
            labelStyle: AppStyles.textButtonStyle.copyWith(
              color: Colors.white,
            ),
          ))
        ],
      );
  Widget _clockedOutWidget() => Row(
        children: [
          Expanded(
              child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                // CupertinoIcons.check_mark_circled_solid,
                Icons.check_circle,
                color: AppColors.otpFieldThemeColorGreen,
                size: 12.h,
              ),
              5.horizontalSpace,
              Text(
                "Work Sheet Updated",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                ),
              ),
            ],
          )),
          Expanded(
              child: RichText(
            text: TextSpan(
                text: "Clocked Inn at  .  ",
                style: AppStyles.onboardingSubTitleTextStyle.copyWith(
                  fontSize: 11.sp,
                ),
                children: [
                  TextSpan(
                    text: "09:16 am",
                    style: AppStyles.onboardingSubTitleTextStyle.copyWith(
                      color: AppColors.primaryActionColorDarkBlue,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ]),
          ))
        ],
      );
}
