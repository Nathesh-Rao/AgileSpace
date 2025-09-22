import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
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
              Container(
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
                    Obx(
                      () => controller.attendanceState.value ==
                              AttendanceState.notPunchedIn
                          ? Expanded(child: _beforeClockedInWidget())
                          : Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  _getAttendanceInfoMainWidget(),
                                  10.horizontalSpace,
                                  _getAttendanceInfoSecondWidget(),
                                ],
                              )),
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
                                fontSize: 11.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ],
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
            Text(
              controller.attendanceState.value == AttendanceState.punchedIn
                  ? controller.clockTimeStatus(
                      "${controller.attendanceDetails.value?.actualOuttime}")
                  : controller.clockTimeStatus(
                      "${controller.attendanceDetails.value?.actualIntime}"),
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
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
                    "Clocked Inn",
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
                    onPressed: controller.onAttendanceClockInCardClick,
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
}
