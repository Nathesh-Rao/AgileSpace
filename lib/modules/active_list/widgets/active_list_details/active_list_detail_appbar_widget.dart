import 'package:axpert_space/common/widgets/chip_card_widget.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';

class ActiveListDetailAppbarWidget extends GetView<ActiveListDetailsController>
    implements PreferredSizeWidget {
  const ActiveListDetailAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Obx(() => Text(
          controller.pendingTaskModel != null
              ? '#${controller.pendingTaskModel!.taskid}'
              : controller.selected_processFlow_taskType.value,
          style: AppStyles.appBarTitleTextStyle.copyWith(
            fontSize: 12.sp,
            color: controller.pendingTaskModel != null
                ? AppColors.primaryActionColorDarkBlue
                : AppColors.chipCardWidgetColorGreen,
            // : AppColors.primaryActionColorDarkBlue,
          )).skeletonLoading(controller.isActiveListDetailsLoading.value)),

      // () => ChipCardWidget(
      //     onMaxSize: true,
      //     label: controller.selected_processFlow_taskType.value,
      //     color: AppColors.baseBlue)).skeletonLoading(
      // controller.isActiveListDetailsLoading.value),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
