import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/attendance/attendance.dart';

import 'package:flutter/material.dart';

import '../../../task/widgets/widgets.dart';
import '../../widgets/landing_drawer_icon_widget.dart';

class LandingTaskTab extends StatelessWidget {
  const LandingTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        leading: LandingDrawerIconWidget(),
        title: AttendanceAppBarTitleWidget(),
        actions: [
          AttendanceAppBarSwitchWidget(),
          25.horizontalSpace,
        ],
      ),
      body: Column(
        children: [
          20.verticalSpace,
          AttendanceClockInWidget(),
          20.verticalSpace,
          TaskSearchActionWidget(),
          TaskListFilterWidget(),
          TaskListPageBuilderWidget()
        ],
      ),
    );
  }
}
