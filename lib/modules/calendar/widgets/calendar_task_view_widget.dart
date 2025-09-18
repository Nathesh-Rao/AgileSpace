import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/empty_widget.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/core/utils/utils.dart';
import 'package:axpert_space/modules/calendar/models/meeting_model.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../controller/calendar_controller.dart' as cl;

class CalendarTaskViewWidget extends GetView<cl.CalendarController> {
  const CalendarTaskViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var meetingList = controller.meetingList.value;
        var meetingEvents = MeetingDataSource(meetingList);
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
            meetingList.isNotEmpty
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
                    child: meetingList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(top: 10.h),
                            itemCount: meetingList.length,
                            itemBuilder: (context, index) =>
                                _buildEvent(meetingList[index]))
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

  Widget _buildEvent(Meeting meeting) {
    var color = AppColors.getRandomColor();
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
                  meeting.eventName,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.primaryTitleTextColorBlueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  meeting.description,
                  maxLines: 4,
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    color: AppColors.primaryTitleTextColorBlueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      DateUtilsHelper.getTodayFormattedDateMD(
                          date: meeting.from),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateUtilsHelper.getTodayFormattedDateMD(date: meeting.to),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
