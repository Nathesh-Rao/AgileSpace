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
    return Obx(() => Expanded(
            child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (Widget child, Animation<double> anim) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.1), // slightly below
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));

            return FadeTransition(
              opacity: anim,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: controller.calendarViewSwitch.value
              ? CalendarTaskViewWidget()
              : CalendarMonthViewWidget(), // give different ValueKeys to trigger animation
        )));
  }
}
