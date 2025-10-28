import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:one_clock/one_clock.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../common/common.dart';
import '../../../core/core.dart';
import '../attendance.dart';

class AttendanceDashBoardWidget extends GetView<AttendanceController> {
  const AttendanceDashBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.attendance);
      },
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
                () => Container(
                  padding: EdgeInsets.all(10.w),
                  width: double.infinity,
                  height: 200.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.violetBorder,
                      )),
                  child: Column(
                    children: [
                      Obx(() => _getAttendanceStateWidget(
                          controller.attendanceState.value)),
                      _bottomInfoWidget(),
                    ],
                  ),
                ).skeletonLoading(
                    controller.isAttendanceDetailsIsLoading.value),
              ),
            ],
          )
        ],
      ),
    );
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

  Widget _actionButton(String text) {
    Color color = text.toLowerCase().contains('inn')
        ? AppColors.chipCardWidgetColorGreen
        : AppColors.baseRed;

    return SizedBox(
      width: double.infinity,
      // padding: EdgeInsets.all(10.w),
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

  Widget _noDetailsAvailableWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.clear_circled_solid,
              color: AppColors.baseRed),
          10.horizontalSpace,
          const Text("No data found"),
        ],
      );

  Widget _dashboardHeadWidget() => Obx(
        () => Visibility(
          visible: (controller.attendanceState.value ==
                  AttendanceState.punchedIn ||
              controller.attendanceState.value == AttendanceState.punchedOut),
          child: Container(
            height: 23.h,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 11.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.r),
                  topLeft: Radius.circular(10.r)),
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
                Text(
                  _getAttendanceInfoHeadText(),
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ).skeletonLoading(false),
        ),
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
          return loadingWidget; // ⏳ while checking permission
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error checking location permission"));
        }

        if (snapshot.hasData) {
          final status = snapshot.data!;

          if (status.isDenied ||
              status.isRestricted ||
              status.isPermanentlyDenied) {
            // 🚫 Show your "no location" widget
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
                10.verticalSpace,
                Expanded(
                  child: PrimaryButtonWidget(
                    height: double.infinity,
                    margin: EdgeInsets.zero,
                    key: ValueKey(controller.attendanceAppbarSwitchValue.value),
                    isLoading: controller.attendanceAppbarSwitchIsLoading.value,
                    onPressed: () {
                      controller.onAttendanceClockInCardClick(false);
                    },
                    label: "ClockInn 🌞",
                    backgroundColor: AppColors.taskClockInWidgetColorPurple,
                    labelStyle: AppStyles.textButtonStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
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

  Widget _bottomInfoWidget() {
    return Obx(
      () => controller.attendanceState.value == AttendanceState.holiday
          ? _actionButton("Clock Inn")
          : controller.attendanceState.value == AttendanceState.punchedOut
              ? SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(
                      color: AppColors.violetBorder.withAlpha(50),
                      borderRadius: BorderRadius.circular(5.r)),
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  margin: EdgeInsets.only(top: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Update your work sheet before clock out",
                        style: GoogleFonts.poppins(
                            fontSize: 11.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
    );
  }
}
