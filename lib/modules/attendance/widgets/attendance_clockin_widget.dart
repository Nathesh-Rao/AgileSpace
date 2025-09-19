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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getInitialAttendanceDetails();
      controller.onAttendanceClockInAnimationEnd();
    });

    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        height: controller.attendanceDetails.value == null
            ? 60.h
            : !controller.attendanceAppbarSwitchValue.value
                ? 106.h
                : 60.h,
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
              child: controller.attendanceDetails.value == null
                  ? SizedBox.shrink()
                  : Row(
                      children: [
                        20.horizontalSpace,
                        Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 10.h,
                        ),
                        5.horizontalSpace,
                        Text(
                          controller.clockInLocation.value
                              .split("\n")[0]
                              .replaceFirst("Name:", "")
                              .trim(),
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
                  child: controller.attendanceDetails.value == null
                      ? _noDetailsAvailableWidget()
                      : !controller.attendanceClockInWidgetCallBackValue.value
                          ? _getWidget()
                          : SizedBox.expand(
                              key: ValueKey(controller
                                  .attendanceClockInWidgetCallBackValue.value),
                            )),
            ),
          ],
        ),
      ).skeletonLoading(controller.isAttendanceDetailsIsLoading.value),
    );
  }

  _getWidget() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: !controller.attendanceAppbarSwitchValue.value
          ? _clockedInWidget()
          : _clockedOutWidget(),
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
                  text: TextSpan(
                      text: "${controller.attendanceDetails.value?.intime}",
                      style: AppStyles.attendanceWidgetTimeStyle,
                      children: [
                        TextSpan(
                            text: " am",
                            style: AppStyles.attendanceWidgetTimeStyle
                                .copyWith(fontSize: 12.sp))
                      ])),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_open_rounded,
                    color: AppColors.blue10,
                    size: 12.h,
                  ),
                  5.horizontalSpace,
                  Text(
                    "Work Sheet ${controller.attendanceDetails.value?.worksheetUpdateStatus}",
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
                Icons.file_open_rounded,
                color: AppColors.blue10,
                size: 12.h,
              ),
              5.horizontalSpace,
              Text(
                "Work Sheet ${controller.attendanceDetails.value?.worksheetUpdateStatus}",
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
                text: "Clocked Out at  .  ",
                style: AppStyles.onboardingSubTitleTextStyle.copyWith(
                  fontSize: 11.sp,
                ),
                children: [
                  TextSpan(
                    text: "${controller.attendanceDetails.value?.outtime}",
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

  Widget _noDetailsAvailableWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10.w,
      children: [
        Icon(
          CupertinoIcons.clear_circled_solid,
          color: AppColors.baseRed,
        ),
        Text("No data found")
      ],
    );
  }
}
