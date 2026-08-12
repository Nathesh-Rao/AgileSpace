import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/empty_widget.dart';
import '../../../core/core.dart';

class ActiveListFloatingButtonWidget extends GetView<ActiveListController> {
  const ActiveListFloatingButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.activeTaskList.isEmpty
          ? Center(
              child: EmptyWidget(
                label: "No Task Data Available",
              ),
            )
          : FloatingActionButton(
              backgroundColor: AppColors.blue9,
              foregroundColor: AppColors.primaryButtonFGColorWhite,
              onPressed: controller.refreshList,
              child: controller.isListLoading.value
                  ? Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryButtonFGColorWhite,
                            strokeWidth: 2,
                            strokeCap: StrokeCap.round,
                          )),
                    )
                  : Icon(controller.isRefreshable.value
                      ? Icons.refresh_rounded
                      : Icons.arrow_upward_rounded),
            ),
    );
  }
}
