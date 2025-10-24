import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/attendance/attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceLogHeaderWidget extends GetView<AttendanceController> {
  const AttendanceLogHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: [
          _dashboardHeadWidget(),
          Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(10.w),
              onEnd: controller.isLogExpandedAssist.toggle,
              width: double.infinity,
              height: controller.isLogExpanded.value ? 136.h : 230.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.violetBorder,
                  )),
              child: controller.isLogExpandedAssist.value
                  ? SizedBox.shrink()
                  : Column(
                      children: [
                        Wrap(
                          children: [
                            AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                reverseDuration: Duration(milliseconds: 200),
                                switchInCurve: Curves.decelerate,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: Tween<double>(begin: 0.1, end: 1)
                                        .animate(animation),
                                    child: child,
                                  );
                                },
                                child: controller.isLogExpanded.value
                                    ? SizedBox.shrink()
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          5.verticalSpace,
                                          Text(
                                            "You are in the Clock-Out area now , Clock-Out available from 6:30 PM",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "Remaining time until you can clock out is 30 min ",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          30.verticalSpace,
                                        ],
                                      )),
                          ],
                        ),
                        Spacer(),
                        SizedBox(
                            height: 100.h,
                            child: Row(
                              children: [
                                _getAttendanceInfoMainWidget(),
                                10.horizontalSpace,
                                _getAttendanceInfoSecondWidget(),
                              ],
                            )),
                        // AnimatedSwitcher(
                        //     duration: const Duration(milliseconds: 400),
                        //     reverseDuration: Duration(milliseconds: 200),
                        //     transitionBuilder: (child, animation) {
                        //       return ScaleTransition(
                        //         scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
                        //         child: child,
                        //       );
                        //     },
                        //     child: controller.isLogExpanded.value
                        //         ? SizedBox.shrink()
                        //         : Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               20.verticalSpace,
                        //               Container(
                        //                 decoration: BoxDecoration(
                        //                     color: AppColors.violetBorder.withAlpha(50), borderRadius: BorderRadius.circular(5.r)),
                        //                 padding: EdgeInsets.symmetric(vertical: 5.h),
                        //                 child: Row(
                        //                   mainAxisAlignment: MainAxisAlignment.center,
                        //                   children: [
                        //                     Text(
                        //                       "Update your work sheet before clock out",
                        //                       style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w600),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               )
                        //             ],
                        //           ))
                      ],
                    ),
            ),
          ),
          20.verticalSpace,
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 200),
              switchInCurve: Curves.decelerate,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.1, end: 1).animate(animation),
                  child: child,
                );
              },
              child: controller.isLogExpanded.value
                  ? const SizedBox.shrink()
                  : _buttonRow(),
            ),
          ),
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
              "30 mins to clock-out",
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
                      text: "09:16",
                      style: AppStyles.attendanceWidgetTimeStyle,
                      children: [
                        TextSpan(
                          text: "am",
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
                "Axpert-house,\nJayanagar 8th block",
                style: AppStyles.attendanceWidgetTimeStyle
                    .copyWith(fontSize: 10.sp),
              ),
              5.verticalSpace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "0m distance to work",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 9.sp,
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
                        "{action}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ))),
          Flexible(
              child: SecondaryButtonWidget(
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
            ))
          ],
        ),
      );
}
