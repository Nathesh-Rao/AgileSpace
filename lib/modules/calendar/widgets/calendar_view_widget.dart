import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/calendar/controller/calendar_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'calendar_month_view_widget.dart';
import 'calendar_task_view_widget.dart';

class CalendarViewWidget extends GetView<CalendarController> {
  const CalendarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllData();
    });
    return Obx(() => Expanded(
            child: AnimatedSwitcherPlus.translationLeft(
          duration: Duration(milliseconds: 500),
          child: controller.calendarViewSwitch.value
              ? CalendarTaskViewWidget()
              : CalendarMonthViewWidget(), // give different ValueKeys to trigger animation
        )));
  }
}
