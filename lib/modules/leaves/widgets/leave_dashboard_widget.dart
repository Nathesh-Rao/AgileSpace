import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';
import '../controller/leave_controller.dart';
import 'leave_dashboard_count_widget.dart';
import 'leave_dashboard_event_widget.dart';

class LeaveDashboardWidget extends GetView<LeaveController> {
  const LeaveDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLeaveActivity();
    });
    return Obx(
      () => (controller.leaveActivity.value == null && controller.isLeaveActivityLoading.value) ||
              (controller.leaveActivity.value != null)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconLabelWidget(iconColor: Color(0xffE0A47A), label: "Leave Activity"),
                10.verticalSpace,
                SizedBox(
                  height: 202.h,
                  child: Row(
                    spacing: 15.w,
                    children: [
                      LeaveDashBoardLeaveCountWidget(),
                      LeaveDashBoardEventWidget(),
                    ],
                  ),
                )
              ],
            )
          : SizedBox.shrink(),
    );
  }
}
