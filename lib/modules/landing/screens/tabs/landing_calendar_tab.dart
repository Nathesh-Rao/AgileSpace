import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/flat_button_widget.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/calendar/widgets/calendar_view_switch_widget.dart';
import 'package:axpert_space/modules/calendar/widgets/calendar_view_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../calendar/widgets/calendar_create_task_widget.dart';

class LandingCalendarTab extends StatelessWidget {
  const LandingCalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateUtilsHelper.getTodayFormattedDate(),
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Today",
                    style: GoogleFonts.poppins(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Spacer(),
              CalendarCreateTaskWidget(),
              10.horizontalSpace,
              CalendarViewSwitchWidget()
            ],
          ),
        ),
        CalendarViewWidget()
      ],
    ));
  }
}
