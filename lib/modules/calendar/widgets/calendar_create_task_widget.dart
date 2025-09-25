import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/calendar/controller/calendar_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../common/widgets/flat_button_widget.dart';
import '../../../core/core.dart';

class CalendarCreateTaskWidget extends GetView<CalendarController> {
  const CalendarCreateTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FlatButtonWidget(
      width: 108.w,
      label: "Add task",
      color: AppColors.chipCardWidgetColorViolet,
      onTap: () {
        controller.navigateToCreateTask();
      },
      // isCompact: true,
    );
  }
}
