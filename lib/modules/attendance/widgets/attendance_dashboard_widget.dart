import 'package:axpert_space/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
                height: 265.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.violetBorder,
                    )),
                child: Column(
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
                        Text(
                          "Remaining time until you can clock out is 30 min ",
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    30.verticalSpace,
                    Obx(
                      () => controller.attendanceAppbarSwitchValue.value
                          ? Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  _getAttendanceInfoMainWidget(),
                                  10.horizontalSpace,
                                  _getAttendanceInfoSecondWidget(),
                                ],
                              ))
                          : Expanded(child: _clockedInWidget()),
                    ),
                    20.verticalSpace,
                    Container(
                      decoration:
                          BoxDecoration(color: AppColors.violetBorder.withAlpha(50), borderRadius: BorderRadius.circular(5.r)),
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Update your work sheet before clock out",
                            style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w600),
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
          borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), topLeft: Radius.circular(10.r)),
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
          decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(10.r)),
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
                  text: TextSpan(text: "09:16", style: AppStyles.attendanceWidgetTimeStyle, children: [
                    TextSpan(
                      text: "am",
                      style: AppStyles.attendanceWidgetTimeStyle.copyWith(fontSize: 12.sp),
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
    return Expanded(
      child: ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(10.r)),
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
                style: AppStyles.attendanceWidgetTimeStyle.copyWith(fontSize: 10.sp),
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

  Widget _clockedInWidget() => ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(10.r)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          "In Location",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            10.horizontalSpace,
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
