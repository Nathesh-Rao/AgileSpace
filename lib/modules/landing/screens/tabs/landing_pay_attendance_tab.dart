import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';
import '../../../attendance/attendance.dart';
import '../../../leaves/leaves.dart';
import '../../../payroll/payroll.dart';

class LandingPayAndAttendanceTab extends StatelessWidget {
  const LandingPayAndAttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
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
            spacing: 15.h,
            children: [
              PayRollDashBoardWidget(),
              AttendanceDashBoardWidget(),
              LeaveDashboardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
