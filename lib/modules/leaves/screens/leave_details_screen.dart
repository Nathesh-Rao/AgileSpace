import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/leaves/controller/leave_controller.dart';
import 'package:axpert_space/modules/leaves/leaves.dart';
import 'package:axpert_space/modules/leaves/widgets/leave_details_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveDetailsScreen extends GetView<LeaveController> {
  const LeaveDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppColors.resetColorIndex();

      controller.getLeaveHistory();
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Leave",
        ),
      ),
      body: Column(
        children: [
          Obx(() => controller.leaveDetailsList.isNotEmpty
              ? LeaveDetailsHeaderWidget()
                  .skeletonLoading(controller.isLeaveDetailsLoading.value)
              : SizedBox.shrink()),
          10.verticalSpace,
          Row(
            children: [
              23.horizontalSpace,
              IconLabelWidget(
                  iconColor: AppColors.snackBarNotificationColorBlue,
                  label: "Leave History"),
            ],
          ),
          5.verticalSpace,
          Expanded(
              child: Obx(
            () => ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    itemCount: controller.leaveHistoryList.length,
                    itemBuilder: (context, index) =>
                        _historyTile(controller.leaveHistoryList[index]))
                .skeletonLoading(controller.isLeaveDetailsLoading.value),
          ))
        ],
      ),
    );
  }

  _historyTile(LeaveHistoryModel leave) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            controller.getColorByLeaveType(leave.leaveType).withAlpha(50),
        child: Center(
          child: Icon(
            controller.getIconByLeaveType(leave.leaveType),
            color: controller.getColorByLeaveType(leave.leaveType),
          ),
        ),
      ),
      title: Text(
        "${leave.leaveType} - ${leave.totalDays} ${leave.totalDays == 1 ? "day" : "days"}",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
      subtitle: Text(
        "${DateUtilsHelper.getShortDayName(leave.fromDate.toString())} ${DateUtilsHelper.getDateNumber(leave.fromDate.toString())}-${DateUtilsHelper.getShortMonthName(leave.toDate.toString())}",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: controller.getColorByLeaveStatus(leave.status).withAlpha(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
        child: Row(
          spacing: 5.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.getIconByLeaveStatus(leave.status),
              size: 13.w,
              color:
                  controller.getColorByLeaveStatus(leave.status).withAlpha(200),
            ),
          ],
        ),
      ),
    );
  }
}
