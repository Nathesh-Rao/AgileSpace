import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpert_space/modules/work_calendar/controller/work_calendar_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';

class WorkCalendarDashboardWidget extends GetView<WorkCalendarController> {
  const WorkCalendarDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconLabelWidget(
                iconColor: AppColors.historyAssigned, label: "Work Calendar"),
            Spacer(),

            _tileInfo(AppColors.blue10.withAlpha(50), "WEEK OFFS"),
            10.horizontalSpace,
            _tileInfo(AppColors.historyAssigned.withAlpha(150), "HOLIDAYS"),
            5.horizontalSpace,

            // Spacer(),
            // Obx(
            //   () => InkWell(
            //       onTap: () {
            //         controller.onDateClick(DateTime.now(), cancelTimer: true);
            //       },
            //       child: AnimatedSwitcherPlus.flipX(
            //         duration: Duration(milliseconds: 400),
            //         child: controller.dateClicked.value
            //             ? Icon(CupertinoIcons.rectangle_expand_vertical)
            //             : Icon(
            //                 CupertinoIcons.rectangle_compress_vertical,
            //               ),
            //       )),
            // )
          ],
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
              border:
                  Border.all(color: AppColors.historyAssigned.withAlpha(100)),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeatMapCalendar(
                defaultColor: Colors.white,
                flexible: true,
                colorMode: ColorMode.color,
                textColor: AppColors.primaryActionColorDarkBlue,
                showColorTip: false,
                datasets: controller.calendarMap,
                colorsets: {
                  1: AppColors.blue10.withAlpha(50),
                  3: AppColors.historyAssigned.withAlpha(150),
                },
                onClick: (value) {
                  controller.onDateClick(value);
                },
              ),
              _dateInfoBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tileInfo(Color color, String s) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: color,
          ),
        ),
        5.horizontalSpace,
        Text(
          s,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: AppColors.text1,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  _dateInfoBox() {
    return Obx(() {
      var color = controller.dateInfo.toLowerCase().contains("nothing")
          ? AppColors.baseRed
          : AppColors.historyAssigned;

      var style = GoogleFonts.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryButtonFGColorWhite,
      );
      return AnimatedContainer(
        curve: Curves.decelerate,
        margin: EdgeInsets.only(top: controller.dateClicked.value ? 5.h : 0),
        duration: Duration(milliseconds: 400),
        height: controller.dateClicked.value ? 50 : 0,
        decoration: BoxDecoration(
          color: color.withAlpha(50),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2.w,
                  children: [
                    Text(
                      // "DEC",
                      DateUtilsHelper.getShortMonthName(
                              controller.selectedDate.toString())
                          .toUpperCase(),
                      style: style,
                    ),
                    Text(
                      "-",
                      style: style,
                    ),
                    Text(
                        DateUtilsHelper.getDateNumber(
                            controller.selectedDate.toString()),
                        style: style),
                  ],
                ),
              ),
            ),
            Expanded(
              child: AutoSizeText(
                controller.dateInfo.value,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
