import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/attendance/attendance.dart';
import 'package:axpert_space/modules/notifications/widgets/notification_icon_widget.dart';
import 'package:axpert_space/modules/web_view/controller/web_view_controller.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_number_flow/flutter_number_flow.dart';
import 'package:get/get.dart';

import '../../../task/widgets/task_list_floating_action_button.dart';
import '../../../task/widgets/widgets.dart';
import '../../widgets/landing_drawer_icon_widget.dart';

class LandingTaskTab extends StatelessWidget {
  const LandingTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      leading: LandingDrawerIconWidget(),
      title: AttendanceAppBarTitleWidget(),
      actions: [
        10.horizontalSpace,
        AttendanceAppBarSwitchWidget(),
        10.horizontalSpace,
        NotificationIconWidget(),
        15.horizontalSpace,
      ],
    );

    final appBarHeight =
        appBar.preferredSize.height + MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: SizedBox(
          height: (1.sh - appBarHeight),
          child: Column(
            children: [
              20.verticalSpace,
              AttendanceClockInWidget(),
              20.verticalSpace,
              TaskSearchActionWidget(),
              TaskListFilterWidget(),
              TaskListPageBuilderWidget()
            ],
          ),
        ),
      ),
      floatingActionButton: TaskListFloatingActionButton(),
    );
  }
}
