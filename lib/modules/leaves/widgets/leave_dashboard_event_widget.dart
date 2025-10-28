import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/leaves/controller/leave_controller.dart';
import 'package:axpert_space/modules/leaves/widgets/leave_dashboard_event_upcoming_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';

class LeaveDashBoardEventWidget extends GetView<LeaveController> {
  const LeaveDashBoardEventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.getLeaveOverview();
    // });
    return Expanded(
        flex: 4,
        child: Obx(
          () => Column(
            spacing: 15.h,
            children: [
              LeaveDashBoardEventUpcomingWidget(),
              _pendingWidget(),
            ],
          ).skeletonLoading(controller.isLeaveOverviewLoading.value),
        ));
  }

  _pendingWidget() {
    var pendingCount = controller.leaveOverviewList.isEmpty
        ? 0
        : controller.leaveOverviewList.first.pendingLeaves;

    return Expanded(
      child: _baseContainer(
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.pie_chart,
                    size: 15.w,
                    color: AppColors.leaveWidgetColorPink,
                  ),
                ),
                Text(
                  "Pending Leave Requests",
                  style: GoogleFonts.poppins(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  10.horizontalSpace,
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.leaveWidgetColorPink,
                    child: Text(
                      pendingCount.toString(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Flexible(
                      child: Text(
                    "You have $pendingCount leave requests pending for approval",
                    style: GoogleFonts.poppins(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                  10.horizontalSpace,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _baseContainer(Widget child) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.secondaryButtonBorderColorGrey,
            )),
        child: child,
      );
}
