import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/empty_widget.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/core/utils/utils.dart';
import 'package:axpert_space/modules/calendar/models/event_model.dart';
import 'package:axpert_space/modules/calendar/models/meeting_model.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/calendar_controller.dart' as cl;

class CalendarTaskViewWidget extends GetView<cl.CalendarController> {
  const CalendarTaskViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var eventList = controller.eventsList;
        return Column(
          children: [
            15.verticalSpace,
            EasyDateTimeLinePicker(
              focusedDate: controller.selectedDate,
              headerOptions: HeaderOptions(
                headerType: HeaderType.none,
              ),
              firstDate: DateTime(2020, 3, 18),
              lastDate: DateTime(2030, 3, 18),
              onDateChange: (date) {
                controller.selectedDate = date;
                controller.getAllData();
              },
            ),
            15.verticalSpace,
            eventList.isNotEmpty
                ? Row(
                    children: [
                      10.horizontalSpace,
                      Text(
                        "Timeline",
                        style: AppStyles.textButtonStyle,
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            Expanded(
                child: AnimatedSwitcherPlus.translationTop(
                    duration: Duration(milliseconds: 400),
                    child: eventList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(top: 10.h),
                            itemCount: eventList.length,
                            itemBuilder: (context, index) =>
                                _buildEvent(eventList[index]))
                        : Center(
                            child: EmptyWidget(
                              label: "No Events found",
                            ),
                          )))
          ],
        );
      },
    );
  }

  Widget _leaveWidget(EventModel event) {
    var color = AppColors.primaryActionColorDarkBlue;

    var title =
        "You were on ${event.description} ${DateUtils.isSameDay(controller.selectedDate, controller.todayDate) ? "Today" : "on ${DateUtilsHelper.getTodayFormattedDateMD(date: controller.selectedDate)}"}.";
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      // color: AppColors.baseGray.withAlpha(70),
      height: 80.h,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryActionColorDarkBlue.withAlpha(20),
        border: Border(
          left: BorderSide(color: color, width: 10.w),
          right: BorderSide(color: color),
          top: BorderSide(color: color),
          bottom: BorderSide(color: color),
        ),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.work_off,
            size: 24.sp,
            color: AppColors.primaryActionColorDarkBlue,
          ),
          8.horizontalSpace,
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryActionColorDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvent(EventModel event) {
    var color = AppColors.getRandomColor();

    var style = GoogleFonts.poppins(
      color: Colors.black87,
      fontSize: 14.sp,
    );

    if (event.recordType.toLowerCase() == 'leave') {
      return _leaveWidget(event);
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 6.h,
        horizontal: 15.w,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.h),
      decoration: BoxDecoration(
          // color: color.withAlpha(50),
          border: Border(
            left: BorderSide(color: color, width: 10.w),
            right: BorderSide(color: color),
            top: BorderSide(color: color),
            bottom: BorderSide(color: color),
          ),
          borderRadius: BorderRadius.circular(7.r)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              spacing: 8.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventName,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.primaryTitleTextColorBlueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  event.description,
                  maxLines: 4,
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    color: AppColors.primaryTitleTextColorBlueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Row(
                //   children: [
                //     Text(
                //       "${event.hrs} hr",
                //       style: GoogleFonts.poppins(
                //         fontSize: 10,
                //         color: Colors.black87,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     Text(
                //       "${event.mns} min",
                //       style: GoogleFonts.poppins(
                //         fontSize: 10,
                //         color: Colors.black87,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ],
                // )

                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: event.hrs,
                      style: style.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      )),
                  TextSpan(
                      text: " hrs",
                      style: style.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      )),
                  TextSpan(
                      text: "  ${event.mns}",
                      style: style.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      )),
                  TextSpan(
                      text: " min",
                      style: style.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ))
                ])),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
