import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDetailsHistorySwitchWidget extends GetView<TaskController> {
  const TaskDetailsHistorySwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(controller.showHistoryFlag.value ? 1.0 : -1.0, 1.0),
          child: Spin(
            key: ValueKey(controller.showHistoryFlag.value),
            spins: 0.5,
            duration: Duration(milliseconds: 300),
            child: IconButton(
              color: controller.showHistoryFlag.value
                  ? AppColors.chipCardWidgetColorRed
                  : AppColors.chipCardWidgetColorGreen,
              onPressed: controller.onShowHistoryIconClick,
              icon: Icon(Icons.history_toggle_off),
            ),
          ),
        ));
  }
}
