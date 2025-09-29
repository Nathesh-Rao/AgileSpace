import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/news_events/widgets/news_events_dashboard_widget.dart';
import 'package:flutter/material.dart';
import '../../../attendance/attendance.dart';
import '../../../leaves/leaves.dart';
import '../../../payroll/payroll.dart';
import '../../../work_calendar/widgets/work_calendar_dashboard_widget.dart';
import '../../widgets/widgets.dart';

class LandingPayAndAttendanceTab extends StatelessWidget {
  const LandingPayAndAttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        // titleSpacing: 0,
        // leading: LandingDrawerIconWidget(),
        title: PayRollAppBarTitleWidget(),
        actions: [
          AttendanceAppBarSwitchWidget(),
          25.horizontalSpace,
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.w),
          child: Column(
            spacing: 20.h,
            children: [
              NewsEventsDashboardWidget(),
              // PayRollDashBoardWidget(),
              WorkCalendarDashboardWidget(),
              AttendanceDashBoardWidget(),
              LeaveDashboardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
