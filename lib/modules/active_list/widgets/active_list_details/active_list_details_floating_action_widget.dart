import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';
import '../../controller/active_list_details_controller.dart';

class ActiveListDetailsFloatingActionWidget
    extends GetView<ActiveListDetailsController> {
  const ActiveListDetailsFloatingActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible:
            controller.selected_processFlow_taskType.toUpperCase() != "MAKE",
        child: FloatingActionButton(
          // mini: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
          backgroundColor: AppColors.floatButtonBaseColorBlueGray,
          foregroundColor: AppColors.primaryTitleTextColorBlueGrey,
          onPressed: controller.toggleTaskDetailsRowOptions,
          child: _getFloatingIcon(),
        ),
      ),
    );
  }

  _getFloatingIcon() {
    if (controller.isActiveListDetailsLoading.value) {
      return CupertinoActivityIndicator(
        color: AppColors.primaryTitleTextColorBlueGrey,
      );
    }

    return !controller.isTaskDetailsRowOptionsExpanded.value
        ? Icon(CupertinoIcons.arrow_up_circle_fill)
        : Icon(CupertinoIcons.arrow_down_circle_fill);
  }
}
