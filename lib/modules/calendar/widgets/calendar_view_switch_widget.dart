import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/calendar/controller/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarViewSwitchWidget extends GetView<CalendarController> {
  const CalendarViewSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: controller.switchCalendarView,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(5.r)),
            padding: EdgeInsets.all(10.w),
            child: Pulse(
              duration: Duration(milliseconds: 500),
              key: ValueKey(controller.calendarViewSwitch.value),
              child: Icon(
                controller.calendarViewSwitch.value
                    ? Icons.calendar_view_month_outlined
                    : Icons.calendar_month_outlined,
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
