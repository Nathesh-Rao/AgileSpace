import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/attendance/attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/AttendanceReportModel.dart';

class AttendanceLogWidget extends GetView<AttendanceController> {
  const AttendanceLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var style = AppStyles.attendanceLogStyle;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAttendanceLog();
    });

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, top: 20.h, right: 20.w),
          child: Row(children: [
            IconLabelWidget(
              iconColor: Color(0xff8371EC),
              label: "Previous Logs",
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Obx(
              () => TextButton.icon(
                onPressed: controller.switchLogExpandValue,
                label: controller.isLogExpanded.value
                    ? Text("See less")
                    : Text("See more"),
                icon: controller.isLogExpanded.value
                    ? Icon(Icons.keyboard_arrow_down_outlined)
                    : Icon(Icons.keyboard_arrow_up_outlined),
              ),
            ),
          ]),
        ),
        15.verticalSpace,
        Obx(() =>
            _attendanceListView(value: controller.selectedMonthIndex.value)),
        10.verticalSpace,
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    offset: Offset(0, -2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ]),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: AppColors.subBGGradientHorizontal),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 42,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Date",
                          style: style.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Clock In",
                          style: style.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(width: 25),
                      Expanded(
                        child: Text(
                          "Clock Out",
                          style: style.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Working Hrs",
                          style: style.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () {
                      if (controller.isAttendanceReportLoading.value) {
                        // return Center(
                        //   child: CircularProgressIndicator(),
                        // );
                        return Column(
                          children: [
                            LinearProgressIndicator(
                              color: Color(0xff3764FC),
                              minHeight: 2,
                            ),
                            Spacer(),
                            FadeInUp(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.decelerate,
                                from: 25,
                                // child: Text.rich(
                                //   TextSpan(text: "Getting ", children: [
                                //     TextSpan(
                                //         text: "${attendanceController.months[attendanceController.selectedMonthIndex.value]}",
                                //         style: GoogleFonts.poppins(
                                //             fontSize: 20, fontWeight: FontWeight.w500, color: MyColors.text1)),
                                //     TextSpan(text: " report...")
                                //   ]),

                                // style: GoogleFonts.poppins(
                                //   fontSize: 15,
                                //   fontWeight: FontWeight.w500,
                                //   color: MyColors.text1,
                                // ),
                                child: Text(
                                  "${controller.months[controller.selectedMonthIndex.value]}\n${controller.selectedYear.value}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.text1),
                                )
                                // ),
                                ),
                            Spacer(),
                          ],
                        );
                      }

                      if (controller.attendanceReportList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/common/no-data.png',
                                width: 200.w,
                              ),
                              5.verticalSpace,
                              Text(
                                "No Data found",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      return FadeInUp(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                        from: 25.h,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: List.generate(
                                controller.attendanceReportList.length,
                                (index) => _attendanceListTile(
                                    controller.attendanceReportList[index])),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _attendanceListTile(AttendanceReportModel data) {
    var style = GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: _getTileWidgetBorderColor(data.status ?? '')))),
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _getTileDateWidget(data),
          ),
          Expanded(
            child: _statusCheck(data.status ?? '')
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.clockIn,
                        style: style,
                        textAlign: TextAlign.start,
                      ),
                      // Text(
                      //   "📍Location",
                      //   style: style.copyWith(
                      //       fontSize: 8,
                      //       fontWeight: FontWeight.w700,
                      //       color: Color(0xff919191)),
                      //   textAlign: TextAlign.start,
                      // ),
                    ],
                  )
                : Text(
                    data.status ?? '',
                    style: style.copyWith(
                      color: _getTileWidgetBorderColor(data.status ?? ""),
                    ),
                  ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _statusCheck(data.status ?? "")
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      data.punchOutTime != null
                          ? Text(
                              data.clockOut,
                              style: style,
                              textAlign: TextAlign.start,
                            )
                          : Text(
                              data.status ?? '',
                              style: style.copyWith(
                                color: _getTileWidgetBorderColor(
                                    data.status ?? ""),
                              ),
                            ),
                      // Text(
                      //   "📍Location",
                      //   style: style.copyWith(
                      //       fontSize: 8,
                      //       fontWeight: FontWeight.w700,
                      //       color: Color(0xff919191)),
                      //   textAlign: TextAlign.start,
                      // ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          Expanded(
            child: Text(
              data.formattedWorkingHours,
              style: style,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTileDateWidget(AttendanceReportModel data) {
    var color = _getTileDateWidgetColor(data.status ?? "");
    var date = data.formattedPunchDate;
    return Row(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: color.withOpacity(0.28),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Expanded(
                  child: Center(
                child: Text(date.split(" ")[0].trim(),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    )),
              )),
              Expanded(
                child: Container(
                  color: color,
                  child: Center(
                    child: Text(
                      date.split(" ")[1].trim(),
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  bool _statusCheck(String status) {
    if (status.toLowerCase().contains("present") ||
        status.toLowerCase().contains("half")) {
      return true;
    }

    return false;
  }

  Color _getTileDateWidgetColor(String status) {
    if (status.toLowerCase().contains("off")) {
      return AppColors.baseRed;
    } else if (status.toLowerCase().contains("leave") ||
        status.toLowerCase().contains("half")) {
      return AppColors.baseYellow;
    } else {
      return AppColors.baseBlue;
    }
  }

  Color _getTileWidgetBorderColor(String status) {
    if (status.toLowerCase().contains("off")) {
      return AppColors.baseRed;
    } else if (status.toLowerCase().contains("leave") ||
        status.toLowerCase().contains("half")) {
      return AppColors.baseYellow;
    } else {
      return AppColors.baseGray;
    }
  }

  Widget _attendanceListView({required int value}) {
    var style = GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500);
    return SizedBox(
      height: 40,
      child: Center(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 15),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              controller.updateMonthIndex(index);
            },
            child: Text(
              controller.months[index],
              style: style.copyWith(
                fontSize: 16.sp,
                color: value == index ? AppColors.baseBlue : AppColors.text1,
                fontWeight:
                    value == index ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(width: 20),
        ),
      ),
    );
  }
}
