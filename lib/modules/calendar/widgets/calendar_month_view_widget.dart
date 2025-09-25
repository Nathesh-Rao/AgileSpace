// import 'package:flutter/cupertino.dart';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/core/utils/extensions.dart';
import 'package:axpert_space/modules/calendar/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/empty_widget.dart';
import '../controller/calendar_controller.dart' as cl;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarMonthViewWidget extends GetView<cl.CalendarController> {
  const CalendarMonthViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Calendar Month View
        SfCalendar(
          view: CalendarView.month,
          headerDateFormat: 'MMMM',
          todayHighlightColor: Colors.purple,
          initialSelectedDate: controller.selectedDate,
          selectionDecoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.purple, width: 2),
          ),
          onSelectionChanged: (calendarSelectionDetails) {
            // setState(() {
            //   _selectedDate = calendarSelectionDetails.date ?? DateTime.now();
            // });
            controller.selectedDate =
                calendarSelectionDetails.date ?? controller.todayDate;
            controller.getAllData();
          },
          monthViewSettings: const MonthViewSettings(
            showAgenda: false,
            appointmentDisplayMode: MonthAppointmentDisplayMode.none,
          ),
        ),

        16.verticalSpace,

        Obx(
          () => Expanded(
            child: AnimatedSwitcherPlus.translationTop(
              duration: Duration(milliseconds: 500),
              child: (!controller.calendarEventLoading.value &&
                      controller.taskList.isEmpty &&
                      controller.eventsList.isEmpty)
                  ? Center(child: EmptyWidget())
                  : ListView(
                      // shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(left: 10.w),
                      children: [
                        15.verticalSpace,
                        controller.eventsList.isNotEmpty
                            ? _buildSectionTitle(
                                "Tasks for ${DateUtils.isSameDay(controller.selectedDate, controller.todayDate) ? "Today" : " - ${DateUtilsHelper.getTodayFormattedDateMD(date: controller.selectedDate)}"}",
                                CupertinoIcons.circle_grid_hex_fill)
                            : SizedBox.shrink(),
                        5.verticalSpace,
                        ...List.generate(
                            controller.eventsList.length,
                            (index) => _buildEvent(controller.eventsList[index],
                                AppColors.getNextColor())),
                        // _buildSectionTitle("Today", Icons.calendar_today),

                        // 15.verticalSpace,
                        // _buildSectionTitle(
                        //     "Events for ${DateUtils.isSameDay(controller.selectedDate, controller.todayDate) ? "Today" : " - ${DateUtilsHelper.getTodayFormattedDateMD(date: controller.selectedDate)}"}",
                        //     CupertinoIcons.dial_fill),
                        // 5.verticalSpace,
                        // ...List.generate(
                        //     controller.taskList.length,
                        //     (index) => _buildEvent(
                        //         controller.taskList[index].caption,
                        //         DateUtilsHelper.getTimeFromDate(controller
                        //             .taskList[index].fromDate
                        //             .toString()),
                        //         AppColors.getNextColor())),
                      ],
                    ).skeletonLoading(controller.calendarEventLoading.value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      // color: AppColors.baseGray.withAlpha(70),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.baseGray.withAlpha(70),
          border: Border(
              left: BorderSide(
                  color: AppColors.primaryActionColorDarkBlue, width: 3.w))),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: AppColors.primaryActionColorDarkBlue,
          ),
          8.horizontalSpace,
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryActionColorDarkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvent(EventModel task, Color color) {
    var style = GoogleFonts.poppins(
      color: Colors.black87,
    );
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.h),
      decoration: BoxDecoration(
          color: color.withAlpha(50),
          border: Border(left: BorderSide(color: color, width: 3.w))),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          8.horizontalSpace,
          Expanded(
            child: Text(
              task.eventName,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacer(),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: task.hrs,
                style: style.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                )),
            TextSpan(
                text: " hrs",
                style: style.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                )),
            TextSpan(
                text: "  ${task.mns}",
                style: style.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                )),
            TextSpan(
                text: " min",
                style: style.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ))
          ])),
          // Text(
          //   "${task.hrs}hrs ${task.mns}mins",
          //   style: GoogleFonts.poppins(
          //     fontSize: 10,
          //     color: Colors.black,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
        ],
      ),
    );
  }
}
