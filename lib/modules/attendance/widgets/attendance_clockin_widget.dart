import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/flat_button_widget.dart';
import 'package:axpert_space/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:one_clock/one_clock.dart';

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
        duration: const Duration(milliseconds: 400),
        curve: Curves.decelerate,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        height:
            (controller.attendanceState.value == AttendanceState.punchedOut ||
                    controller.attendanceState.value == AttendanceState.error)
                ? 60.h
                : 116.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: controller.attendanceState.value == AttendanceState.holiday
              ? AppColors.baseYellow
              : controller.attendanceState.value == AttendanceState.leave
                  ? AppColors.flatButtonColorBlue
                  : AppColors.taskClockInWidgetColorPurple,
        ),
        child: Column(
          children: [
            if (controller.attendanceDetails.value != null)
              if (controller.attendanceState.value != AttendanceState.leave &&
                  controller.attendanceState.value != AttendanceState.holiday)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: _locationWidget(),
                ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.white,
                ),
                child: Obx(_getWidget),
              ),
            ),
          ],
        ),
      ).skeletonLoading(controller.isAttendanceDetailsIsLoading.value),
    );
  }

  Widget _getWidget() {
    switch (controller.attendanceState.value) {
      case AttendanceState.notPunchedIn:
        return _beforeClockInWidget();
      case AttendanceState.punchedIn:
        return _clockedInWidget();
      case AttendanceState.punchedOut:
        return _clockedOutWidget();
      case AttendanceState.error:
        return _noDetailsAvailableWidget();
      case AttendanceState.leave:
        return _leaveWidget();
      case AttendanceState.holiday:
        return _holidayWidget();
    }
  }

  Widget _clockWidget() => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: AnalogClock(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          isLive: true,
          hourHandColor: AppColors.primaryActionColorDarkBlue,
          minuteHandColor: AppColors.primaryActionColorDarkBlue,
          showSecondHand: true,
          numberColor: AppColors.primaryActionColorDarkBlue,
          secondHandColor: AppColors.baseRed,
          showNumbers: true,
          showAllNumbers: true,
          textScaleFactor: 1,
          showTicks: true,
          showDigitalClock: true,
          datetime: DateTime.now(),
        ),
      );

  Widget _statusChip(String text, Color color) => Container(
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.all(5.h),
        width: 100.w,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 7.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      );

  Widget _actionButton(String text) {
    Color color = text.toLowerCase().contains('Inn')
        ? AppColors.chipCardWidgetColorGreen
        : AppColors.baseRed;

    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(10.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(5.w),
            elevation: 0,
            backgroundColor: color.withAlpha(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            )),
        onPressed: () {
          controller.showDLG();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.w,
          children: [
            // Icon(
            //   CupertinoIcons.dial_fill,
            //   color: color,
            // ),

            Text(
              text,
              style: AppStyles.textButtonStyleNormal.copyWith(
                  color: color, fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            Image.asset(
              "assets/images/common/clock_inn.png",
              width: 24.w,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  //  InkWell(
  //       onTap: () {
  //         controller.showDLG();
  //       },
  //       child: Container(
  //         margin: EdgeInsets.all(10.h),
  //         decoration: BoxDecoration(
  //           color: AppColors.taskClockInWidgetColorPurple,
  //           // image: DecorationImage(
  //           //     image: AssetImage("assets/icons/common/ morning.jpg"),
  //           //     colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstATop),
  //           //     fit: BoxFit.cover),
  //           borderRadius: BorderRadius.circular(8.r),
  //           // border: Border.all(
  //           //     color: AppColors.taskClockInWidgetColorPurple, width: 0.5),
  //         ),
  //         child: Center(
  //           child: Text(
  //             text,
  //             style: GoogleFonts.poppins(
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.w500,
  //               color: AppColors.primaryButtonFGColorWhite,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );

  Widget _beforeClockInWidget() => Row(
        children: [
          Flexible(flex: 2, child: _clockWidget()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _statusChip(
                    controller.clockTimeStatus(
                        "${controller.attendanceDetails.value?.actualIntime}"),
                    AppColors.chipCardWidgetColorBlue,
                  ),
                ),
                5.verticalSpace,
                Expanded(
                  child: _statusChip(
                    "Work Sheet ${controller.attendanceDetails.value?.worksheetUpdateStatus}",
                    ("${controller.attendanceDetails.value?.worksheetUpdateStatus}"
                                .toLowerCase()
                                .contains("not") ||
                            "${controller.attendanceDetails.value?.worksheetUpdateStatus}"
                                .toLowerCase()
                                .contains("null"))
                        ? AppColors.chipCardWidgetColorRed
                        : AppColors.chipCardWidgetColorGreen,
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          Expanded(flex: 3, child: _actionButton("Clock Inn")),
          5.horizontalSpace,
        ],
      );

  Widget _clockedInWidget() => Row(
        children: [
          Flexible(flex: 2, child: _clockWidget()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.chipCardWidgetColorBlue.withAlpha(30),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      padding: EdgeInsets.all(5.h),
                      width: 100.w,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Clocked Inn at :",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 7.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.chipCardWidgetColorBlue,
                              ),
                            ),
                            AutoSizeText(
                              "${controller.attendanceDetails.value?.intime}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.chipCardWidgetColorBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                5.verticalSpace,
                Expanded(
                  child: _statusChip(
                    "Work Sheet ${controller.attendanceDetails.value?.worksheetUpdateStatus}",
                    ("${controller.attendanceDetails.value?.worksheetUpdateStatus}"
                                .toLowerCase()
                                .contains("not") ||
                            "${controller.attendanceDetails.value?.worksheetUpdateStatus}"
                                .toLowerCase()
                                .contains("null"))
                        ? AppColors.chipCardWidgetColorRed
                        : AppColors.chipCardWidgetColorGreen,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 3, child: _actionButton("Clock Out")),
        ],
      );

  Widget _clockedOutWidget() => Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.file_open_rounded,
                  color:
                      "${controller.attendanceDetails.value?.worksheetUpdateStatus}"
                              .toLowerCase()
                              .contains("not")
                          ? AppColors.chipCardWidgetColorRed
                          : AppColors.blue10,
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
          ),
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
                ],
              ),
            ),
          )
        ],
      );

  Widget _noDetailsAvailableWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.clear_circled_solid,
              color: AppColors.baseRed),
          10.horizontalSpace,
          const Text("No data found"),
        ],
      );

  Widget _leaveWidget() {
    var message =
        controller.attendanceDetails.value?.message.toLowerCase() ?? '';
    var text = "";
    var image = "assets/lotties/relaxing.json";
    if (message.contains("sick")) {
      text = "Hope you feel better soon! 🛌 Take care today.";
      image = "assets/lotties/sick1.json";
    } else if (message.contains("earned")) {
      text = "Enjoy your well-deserved leave today! ⛴️";
    } else if (message.contains("casual")) {
      text = "Take it easy and enjoy your casual leave! ☀️";
      image = "assets/lotties/car.json";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(10.w),
          child: Lottie.asset(
            image,
            // width: 150.w,
            // height: 150.w,
            // fit: BoxFit.cover,
          ),
        ),
        10.horizontalSpace,
        Expanded(
            child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.flatButtonColorBlue.withAlpha(30),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: AppColors.flatButtonColorBlue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )),
      ],
    );
  }

  Widget _holidayWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Lottie.asset("assets/lotties/relaxing2.json"),
          ),
          10.horizontalSpace,
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.baseYellow.withAlpha(10),
            ),
            child: Center(
              child: Text(
                "Happy Holidays! Enjoy your day off! 🚌",
                style: GoogleFonts.poppins(
                  color: AppColors.baseYellow,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )),
        ],
      );
  Widget _locationWidget() => Obx(() => AnimatedSwitcherPlus.flipY(
        duration: Duration(milliseconds: 500),
        child: controller.isAddrsFetchLoading.value
            ? Row(
                children: [
                  20.horizontalSpace,
                  CupertinoActivityIndicator(
                    radius: 5.w,
                    color: AppColors.primaryButtonFGColorWhite,
                  ),
                  5.horizontalSpace,
                  Text(
                    "Fetching current address....",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  20.horizontalSpace
                ],
              )
            : Row(
                children: [
                  20.horizontalSpace,
                  Icon(Icons.my_location, color: Colors.white, size: 10.h),
                  5.horizontalSpace,
                  Flexible(
                    child: AutoSizeText(
                      maxFontSize: 8,
                      minFontSize: 8,
                      controller.clockInLocation.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
      ));
}
