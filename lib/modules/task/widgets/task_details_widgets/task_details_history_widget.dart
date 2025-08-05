import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets.dart';
import 'task_details_history_horizontal_list.dart';

class TaskDetailsHistoryWidget extends GetView<TaskController> {
  const TaskDetailsHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        onEnd: controller.onHistoryWidgetAnimationEndCallBack,
        height: _getContainerHeight(),
        decoration: BoxDecoration(
          color: Color(0xffFAFAFA),
        ),
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        child: Center(
          child: controller.isTaskDetailsLoading.value
              ? RainbowLoadingWidget()
              : AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return controller.showHistoryFlag.value
                        ? FadeTransition(opacity: animation, child: child)
                        : FadeTransition(opacity: animation, child: child);
                  },
                  child: controller.showHistoryFlag.value
                      ? TaskDetailsHistoryVerticalListWidget(key: ValueKey('visible'))
                      : TaskDetailsHistoryHorizontalListWidget(key: ValueKey('invisible')),
                ),
          //,
        ),
      ),
    );
  }

  double _getContainerHeight() {
    if (controller.isTaskDetailsLoading.value) return 5.h;

    if (controller.showHistoryFlag.value) {
      final count = controller.taskHistoryList.length;

      if (count < 3) {
        return (count * 155).h;
      } else {
        return 464.h;
      }
    } else {
      return 55.h;
    }
  }
}
