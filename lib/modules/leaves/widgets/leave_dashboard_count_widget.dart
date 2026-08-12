import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/leaves/controller/leave_controller.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/core.dart';
import 'leave_progress_widget.dart';

class LeaveDashBoardLeaveCountWidget extends GetView<LeaveController> {
  const LeaveDashBoardLeaveCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Obx(
        () => controller.leaveDetailsList.isEmpty
            ? _emptyWidget()
            : Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.secondaryButtonBorderColorGrey,
                    )),
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
                      style: AppStyles.leaveActivityMainStyle
                          .copyWith(fontSize: 7.sp),
                    ),
                    Text(
                      DateUtilsHelper.getShortMonthName(
                          DateTime.now().toString()),
                      style: AppStyles.leaveActivityMainStyle
                          .copyWith(fontSize: 14.sp),
                    ),
                    10.verticalSpace,
                  ],
                ),
              ).skeletonLoading((controller.isLeaveDetailsLoading.value ||
                controller.isLeaveOverviewLoading.value)),
      ),
    );
  }

  Widget _emptyWidget() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.baseRed.withAlpha(50),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Column(
          spacing: 10.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.error, color: AppColors.baseRed),
            Text(
              "no leave details found for user ${globalVariableController.USER_NAME}",
              textAlign: TextAlign.center,
              style: AppStyles.actionButtonStyle
                  .copyWith(color: AppColors.baseRed, fontSize: 10.sp),
            )
          ],
        ),
      ),
    );
  }
}
