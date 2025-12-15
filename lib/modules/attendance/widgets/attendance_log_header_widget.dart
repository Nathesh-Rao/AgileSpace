import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/flat_button_widget.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/attendance/attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:one_clock/one_clock.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceLogHeaderWidget extends GetView<AttendanceController> {
  const AttendanceLogHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: [
          Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 400),
              padding: EdgeInsets.all(10.w),
              width: double.infinity,
              height: controller.isLogExpanded.value ? 180.h : 230.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.violetBorder,
                  )),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.only(bottom: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      // border: Border.all(
                      //   color: AppColors.violetBorder,
                      // ),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientBlue,
                          AppColors.gradientViolet,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    height: controller.isLogExpanded.value ? 35.h : 70.h,
                    child: Center(
                        child: Text(
                      _getAttendanceInfoHeadText(),
                      style: AppStyles.actionButtonStyle
                          .copyWith(color: Colors.white),
                    )),
                  ),
                  _getAttendanceStateWidget(controller.attendanceState.value),
                ],
              ),
            ).skeletonLoading(controller.isAttendanceDetailsIsLoading.value),
          ),
          Obx(() => AnimatedSwitcherPlus.revealY(
                duration: Duration(milliseconds: 400),
                child: controller.isLogExpanded.value
                    ? SizedBox.shrink()
                    : _getActionButtonWidget(controller.attendanceState.value),
              ).skeletonLoading(controller.isAttendanceDetailsIsLoading.value))
        ],
      ),
    );

    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    //   child: Column(
    //     children: [
    //       _dashboardHeadWidget(),
    //       Obx(
    //         () => AnimatedContainer(
    //           duration: Duration(milliseconds: 200),
    //           padding: EdgeInsets.all(10.w),
    //           onEnd: controller.isLogExpandedAssist.toggle,
    //           width: double.infinity,
    //           height: controller.isLogExpanded.value ? 136.h : 230.h,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10.r),
    //               border: Border.all(
    //                 color: AppColors.violetBorder,
    //               )),
    //           child: controller.isLogExpandedAssist.value
    //               ? SizedBox.shrink()
    //               : Column(
    //                   children: [
    //                     Wrap(
    //                       children: [
    //                         AnimatedSwitcher(
    //                             duration: const Duration(milliseconds: 400),
    //                             reverseDuration: Duration(milliseconds: 200),
    //                             switchInCurve: Curves.decelerate,
    //                             transitionBuilder: (child, animation) {
    //                               return FadeTransition(
    //                                 opacity: Tween<double>(begin: 0.1, end: 1)
    //                                     .animate(animation),
    //                                 child: child,
    //                               );
    //                             },
    //                             child: controller.isLogExpanded.value
    //                                 ? SizedBox.shrink()
    //                                 : Column(
    //                                     mainAxisSize: MainAxisSize.min,
    //                                     children: [
    //                                       5.verticalSpace,
    //                                       Text(
    //                                         "You are in the Clock-Out area now , Clock-Out available from 6:30 PM",
    //                                         style: GoogleFonts.poppins(
    //                                           fontSize: 14.sp,
    //                                           fontWeight: FontWeight.w600,
    //                                         ),
    //                                       ),
    //                                       Row(
    //                                         children: [
    //                                           Flexible(
    //                                             child: Text(
    //                                               "Remaining time until you can clock out is 30 min ",
    //                                               style: GoogleFonts.poppins(
    //                                                 fontSize: 11.sp,
    //                                                 fontWeight: FontWeight.w500,
    //                                               ),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                       30.verticalSpace,
    //                                     ],
    //                                   )),
    //                       ],
    //                     ),
    //                     Spacer(),
    //                     // SizedBox(
    //                     //     height: 100.h,
    //                     //     child: Row(
    //                     //       children: [
    //                     //         _getAttendanceInfoMainWidget(),
    //                     //         10.horizontalSpace,
    //                     //         _getAttendanceInfoSecondWidget(),
    //                     //       ],
    //                     //     )),

    //                     SizedBox(
    //                       height: 100.h,
    //                       child: Obx(() => _getAttendanceStateWidget(
    //                           controller.attendanceState.value)),
    //                     ),

    //                     // Container(
    //                     //   padding: EdgeInsets.all(10.w),
    //                     //   width: double.infinity,
    //                     //   height: 200.h,
    //                     //   decoration: BoxDecoration(
    //                     //       borderRadius: BorderRadius.circular(10.r),
    //                     //       border: Border.all(
    //                     //         color: AppColors.violetBorder,
    //                     //       )),
    //                     //   child: Column(
    //                     //     children: [
    //                     //       Obx(() => _getAttendanceStateWidget(
    //                     //           controller.attendanceState.value)),
    //                     //     ],
    //                     //   ),

    //                     // ),
    //                   ],
    //                 ),
    //         ),
    //       ),
    //       20.verticalSpace,
    //       Obx(
    //           // () => AnimatedSwitcher(
    //           //   duration: const Duration(milliseconds: 400),
    //           //   reverseDuration: Duration(milliseconds: 200),
    //           //   switchInCurve: Curves.decelerate,
    //           //   transitionBuilder: (child, animation) {
    //           //     return FadeTransition(
    //           //       opacity: Tween<double>(begin: 0.1, end: 1).animate(animation),
    //           //       child: child,
    //           //     );
    //           //   },
    //           //   child: controller.isLogExpanded.value
    //           //       ? const SizedBox.shrink()
    //           //       : _buttonRow(),
    //           // ),

    //           () => AnimatedSwitcherPlus.revealY(
    //                 duration: Duration(milliseconds: 400),
    //                 child: controller.isLogExpanded.value
    //                     ? const SizedBox.shrink()
    //                     : _buttonRow(),
    //               )),
    //     ],
    //   ),
    // );
  }

  Widget _getAttendanceStateWidget(AttendanceState state) {
    switch (state) {
      case AttendanceState.notPunchedIn:
        return Expanded(child: _beforeClockedInWidget());
      case AttendanceState.punchedIn:
        return Expanded(
            flex: 2,
            child: Row(
              children: [
                _getAttendanceInfoMainWidget(),
                10.horizontalSpace,
                _getAttendanceInfoSecondWidget(),
              ],
            ));
      case AttendanceState.punchedOut:
        return Expanded(child: _punchedOutWidget());
      case AttendanceState.leave:
        return Expanded(child: _leaveWidget());
      case AttendanceState.holiday:
        return Expanded(child: _holidayWidget());
      case AttendanceState.error:
        return Expanded(child: _noDetailsAvailableWidget());
    }
  }

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

  Widget _punchedOutWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Lottie.asset("assets/lotties/cycle.json"),
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
                "You have been successfully Clocked Out! 🚌",
                style: GoogleFonts.poppins(
                  color: AppColors.baseYellow,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )),
        ],
      );
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

  Widget _beforeClockedInWidget() => ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Row(
          children: [
            Expanded(child: _clockWidget()),
            Expanded(
                child: Column(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.chipCardWidgetColorBlue.withAlpha(30),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.location_circle,
                        color: AppColors.chipCardWidgetColorBlue,
                      ),
                      10.horizontalSpace,
                      Obx(() => Flexible(
                            child: AutoSizeText(
                              maxFontSize: 10,
                              minFontSize: 3,
                              controller.clockInLocation.value,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: AppColors.chipCardWidgetColorBlue,
                              ),
                            ),
                          ))
                    ],
                  ),
                )),
                // 10.verticalSpace,
                // Expanded(
                //   child: PrimaryButtonWidget(
                //     height: double.infinity,
                //     margin: EdgeInsets.zero,
                //     key: ValueKey(controller.attendanceAppbarSwitchValue.value),
                //     isLoading: controller.attendanceAppbarSwitchIsLoading.value,
                //     onPressed: controller.onAttendanceClockInCardClick,
                //     label: "ClockInn 🌞",
                //     backgroundColor: AppColors.taskClockInWidgetColorPurple,
                //     labelStyle: AppStyles.textButtonStyle.copyWith(
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ))
          ],
        ),
      );

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

  Widget statusChip(String text, Color color) => Container(
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

  Widget _getActionButtonWidget(AttendanceState state) {
    var bgColor = AppColors.blue9;
    var primaryLabel = '';
    var isVisible = true;
    var isPunchedInn = false;

    switch (state) {
      case AttendanceState.notPunchedIn:
        primaryLabel = "Clock In";
        bgColor = AppColors.chipCardWidgetColorGreen;
        isVisible = true;
        isPunchedInn = false;
        break;

      case AttendanceState.punchedIn:
        primaryLabel = "Clock Out";
        bgColor = AppColors.baseRed;
        isVisible = true;
        isPunchedInn = true;
        break;

      case AttendanceState.punchedOut:
      case AttendanceState.leave:
      case AttendanceState.holiday:
      case AttendanceState.error:
        primaryLabel = "";
        bgColor = AppColors.blue9;
        isVisible = false;
        isPunchedInn = false;
        break;
    }

    return Row(spacing: 10.w, children: [
      Flexible(
          child: SecondaryButtonWidget(
              margin: EdgeInsets.only(top: 10.h),
              backgroundColor: AppColors.blue10,
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5.w,
                children: [
                  Icon(
                    Icons.access_alarm_outlined,
                    size: 18.w,
                    color: Colors.white,
                  ),
                  Text(
                    "Action",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ))),
      if (isVisible)
        Flexible(
            child: SecondaryButtonWidget(
                margin: EdgeInsets.only(top: 10.h),
                backgroundColor: bgColor,
                onPressed: () {
                  controller.onAttendnaceLogClockButtonClick(isPunchedInn);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5.w,
                  children: [
                    Icon(
                      CupertinoIcons.hand_point_right_fill,
                      size: 18.w,
                      color: Colors.white,
                    ),
                    Text(
                      primaryLabel,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )))
    ]);
  }

  Widget _buttonRow() => Row(
        spacing: 10.w,
        children: [
          Flexible(
              child: SecondaryButtonWidget(
                  margin: EdgeInsets.zero,
                  backgroundColor: AppColors.blue10,
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5.w,
                    children: [
                      Icon(
                        Icons.access_alarm_outlined,
                        size: 18.w,
                        color: Colors.white,
                      ),
                      Text(
                        "Action",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ))),
          Flexible(
              child: SecondaryButtonWidget(
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  backgroundColor: AppColors.blue9,
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5.w,
                    children: [
                      Icon(
                        CupertinoIcons.hand_point_right_fill,
                        size: 18.w,
                        color: Colors.white,
                      ),
                      Text(
                        "Clock out",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ))),
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

  _getAttendanceInfoHeadText() {
    var text = '';
    switch (controller.attendanceState.value) {
      case AttendanceState.punchedIn:
        text = controller.clockTimeStatus(
            "${controller.attendanceDetails.value?.actualOuttime}");
        break;
      case AttendanceState.punchedOut:
        text = "Punched out at ${controller.attendanceDetails.value?.outtime}";
        break;
      case AttendanceState.holiday:
        text = "HOLIDAY";
        break;
      case AttendanceState.leave:
        text = "On Leave";
        break;
      default:
        text = controller.clockTimeStatus(
            "${controller.attendanceDetails.value?.actualIntime}");
    }

    controller.attendanceState.value == AttendanceState.punchedIn
        ? controller.clockTimeStatus(
            "${controller.attendanceDetails.value?.actualOuttime}")
        : controller.clockTimeStatus(
            "${controller.attendanceDetails.value?.actualIntime}");
    return text;
  }

  Widget _getAttendanceInfoMainWidget() {
    return Expanded(
      child: ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10.r)),
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColors.chipCardWidgetColorGreen,
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5.w,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 10.h,
                        color: AppColors.chipCardWidgetColorGreen,
                      ),
                      Text(
                        // controller.clockedInTimeStatus(${controller.attendanceDetails.value?.intime}, expectedTimeStr),
                        "",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              RichText(
                  key: ValueKey(controller.attendanceAppbarSwitchValue.value),
                  text: TextSpan(
                      text: "${controller.attendanceDetails.value?.intime}",
                      style: AppStyles.attendanceWidgetTimeStyle,
                      children: [
                        TextSpan(
                          text: "",
                          style: AppStyles.attendanceWidgetTimeStyle
                              .copyWith(fontSize: 12.sp),
                        )
                      ])),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Clocked In",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAttendanceInfoSecondWidget() {
    var signInWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.my_location,
                color: AppColors.chipCardWidgetColorRed,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5.w,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 10.h,
                    color: AppColors.chipCardWidgetColorGreen,
                  ),
                  Text(
                    "In Office",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          Obx(
            () => Text(
              // "${controller.clockInLocation.value.split("\n")[0].replaceFirst("Name:", "").trim()}\n${controller.clockInLocation.value.split("\n")[4].replaceFirst("Postal code:", "").trim()}",
              controller.clockInLocation.value,
              style:
                  AppStyles.attendanceWidgetTimeStyle.copyWith(fontSize: 10.sp),
            ),
          ),
          5.verticalSpace,
        ],
      ),
    );

    var signOutWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.chipCardWidgetColorGreen,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5.w,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 10.h,
                    color: AppColors.chipCardWidgetColorGreen,
                  ),
                  Text(
                    "On time",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          RichText(
              key: ValueKey(controller.attendanceAppbarSwitchValue.value),
              text: TextSpan(
                  text: "${controller.attendanceDetails.value?.outtime}",
                  style: AppStyles.attendanceWidgetTimeStyle,
                  children: [
                    TextSpan(
                      text: "",
                      style: AppStyles.attendanceWidgetTimeStyle
                          .copyWith(fontSize: 12.sp),
                    )
                  ])),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Clocked Out",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    var noLocationWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.baseRed.withAlpha(50)),
          borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.all(1.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.baseRed.withAlpha(20),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.location_circle,
                color: AppColors.baseRed,
              ),
              10.verticalSpace,
              Text(
                "Location is disabled",
                style: AppStyles.actionButtonStyle.copyWith(
                  color: AppColors.baseRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    var loadingWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.blue10.withAlpha(50)),
          borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.all(1.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.blue10.withAlpha(20),
        ),
        child: Center(
          child: CupertinoActivityIndicator(
            color: AppColors.blue10,
          ),
        ),
      ),
    );

    return FutureBuilder<PermissionStatus>(
      future: Permission.location.status,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
              child: ZoomIn(
                  duration: const Duration(milliseconds: 400),
                  child: loadingWidget));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error checking location permission"));
        }

        if (snapshot.hasData) {
          final status = snapshot.data!;

          if (status.isDenied ||
              status.isRestricted ||
              status.isPermanentlyDenied) {
            return noLocationWidget;
          }

          if (controller.isClockedOut.value) {
            return Expanded(
              child: ZoomIn(
                duration: const Duration(milliseconds: 400),
                child: signOutWidget,
              ),
            );
          }

          return Expanded(
            child: ZoomIn(
              duration: const Duration(milliseconds: 400),
              child: signInWidget,
            ),
          );
        }

        return loadingWidget;
      },
    );
  }
}

class AttendanceLogHeaderWidget1 extends GetView<AttendanceController> {
  const AttendanceLogHeaderWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconLabelWidget(iconColor: Color(0xff8371EC), label: "Attendance"),
          10.verticalSpace,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dashboardHeadWidget(),
              Obx(
                () => AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  onEnd: controller.isLogExpandedAssist.toggle,
                  padding: EdgeInsets.all(10.w),
                  width: double.infinity,
                  height: controller.isLogExpanded.value ? 220.h : 265.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.violetBorder,
                      )),
                  child: Obx(
                    () => controller.isLogExpandedAssist.value
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              controller.isLogExpanded.value
                                  ? SizedBox.shrink()
                                  : controller.isClockedIn.value
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            5.verticalSpace,
                                            Text(
                                              "You are in the Clock-Out area now , Clock-Out available from ${controller.attendanceDetails.value?.actualOuttime}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Remaining time until you can clock out is 0 min ",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "Please clock in before ${controller.attendanceDetails.value?.actualIntime}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              30.verticalSpace,
                              Obx(
                                () => controller.isClockedIn.value
                                    ? Expanded(
                                        child: Row(
                                        children: [
                                          _getAttendanceInfoMainWidget(),
                                          10.horizontalSpace,
                                          _getAttendanceInfoSecondWidget(),
                                        ],
                                      ))
                                    : Expanded(child: _beforeClockedInWidget()),
                              ),
                              20.verticalSpace,
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.violetBorder.withAlpha(50),
                                    borderRadius: BorderRadius.circular(5.r)),
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Update your work sheet before clock out",
                                      style: GoogleFonts.poppins(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _dashboardHeadWidget() => Container(
        height: 23.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 11.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.r), topLeft: Radius.circular(10.r)),
          gradient: LinearGradient(
            colors: [
              AppColors.gradientBlue,
              AppColors.gradientViolet,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            10.horizontalSpace,
            Obx(
              () => Text(
                "60 mins to clock-out ${controller.isLogExpandedAssist.value}",
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ).skeletonLoading(false);

  Widget _getAttendanceInfoMainWidget() {
    return Expanded(
      child: ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10.r)),
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColors.chipCardWidgetColorGreen,
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5.w,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 10.h,
                        color: AppColors.chipCardWidgetColorGreen,
                      ),
                      Text(
                        "On time",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              RichText(
                  key: ValueKey(controller.attendanceAppbarSwitchValue.value),
                  text: TextSpan(
                      text: "${controller.attendanceDetails.value?.intime}",
                      style: AppStyles.attendanceWidgetTimeStyle,
                      children: [
                        TextSpan(
                          text: "",
                          style: AppStyles.attendanceWidgetTimeStyle
                              .copyWith(fontSize: 12.sp),
                        )
                      ])),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Clocked In",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAttendanceInfoSecondWidget() {
    var signInWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.my_location,
                color: AppColors.chipCardWidgetColorRed,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5.w,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 10.h,
                    color: AppColors.chipCardWidgetColorGreen,
                  ),
                  Text(
                    "In Office",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          Text(
            "${controller.clockInLocation.value.split("\n")[0].replaceFirst("Name:", "").trim()}\n${controller.clockInLocation.value.split("\n")[4].replaceFirst("Postal code:", "").trim()}",
            style:
                AppStyles.attendanceWidgetTimeStyle.copyWith(fontSize: 10.sp),
          ),
          5.verticalSpace,
        ],
      ),
    );

    var signOutWidget = Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.chipCardWidgetColorGreen,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5.w,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 10.h,
                    color: AppColors.chipCardWidgetColorGreen,
                  ),
                  Text(
                    "On time",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
          Spacer(),
          RichText(
              key: ValueKey(controller.attendanceAppbarSwitchValue.value),
              text: TextSpan(
                  text: "${controller.attendanceDetails.value?.outtime}",
                  style: AppStyles.attendanceWidgetTimeStyle,
                  children: [
                    TextSpan(
                      text: "",
                      style: AppStyles.attendanceWidgetTimeStyle
                          .copyWith(fontSize: 12.sp),
                    )
                  ])),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Clocked Out",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (controller.isClockedOut.value) {
      return Expanded(
        child: ZoomIn(
          duration: Duration(milliseconds: 400),
          child: signOutWidget,
        ),
      );
    }

    return Expanded(
      child: ZoomIn(
        duration: Duration(milliseconds: 400),
        child: signInWidget,
      ),
    );
  }

  Widget _beforeClockedInWidget() => ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Row(
          children: [
            // Expanded(
            //     child: PrimaryButtonWidget(
            //   height: double.infinity,
            //   margin: EdgeInsets.zero,
            //   key: ValueKey(controller.attendanceAppbarSwitchValue.value),
            //   isLoading: controller.attendanceAppbarSwitchIsLoading.value,
            //   onPressed: controller.onAttendanceClockInCardClick,
            //   label: "ClockInn 🌞",
            //   backgroundColor: AppColors.taskClockInWidgetColorPurple,
            //   labelStyle: AppStyles.textButtonStyle.copyWith(
            //     color: Colors.white,
            //   ),
            // ))
          ],
        ),
      );
}
