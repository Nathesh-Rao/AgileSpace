import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/leaves/controller/leave_controller.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';
import 'leave_progress_widget.dart';

class LeaveDashBoardLeaveCountWidget extends GetView<LeaveController> {
  const LeaveDashBoardLeaveCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.secondaryButtonBorderColorGrey,
              )),
          child: GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.leaveDetails);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.info_rounded,
                        size: 15.w,
                        color: AppColors.leaveWidgetColorSandal,
                      ),
                    ),
                  ],
                ),
                LeaveProgressWidget(),
                Text(
                  "Leave balance for month",
                  style:
                      AppStyles.leaveActivityMainStyle.copyWith(fontSize: 7.sp),
                ),
                Text(
                  DateUtilsHelper.getShortMonthName(DateTime.now().toString()),
                  style: AppStyles.leaveActivityMainStyle
                      .copyWith(fontSize: 14.sp),
                ),
                10.verticalSpace,
              ],
            ),
          ),
        ).skeletonLoading((controller.isLeaveDetailsLoading.value ||
            controller.isLeaveOverviewLoading.value)),
      ),
    );
  }
}
