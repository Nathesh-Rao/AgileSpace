import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:axpert_space/modules/task/models/task_row_options_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../common/widgets/flat_button_widget.dart';
import '../../../core/core.dart';

class TaskTileActionButtonWidget extends StatefulWidget {
  const TaskTileActionButtonWidget({super.key, required this.task});
  final TaskListModel task;
  @override
  State<TaskTileActionButtonWidget> createState() =>
      _TaskTileActionButtonWidgetState();
}

class _TaskTileActionButtonWidgetState
    extends State<TaskTileActionButtonWidget> {
  final TaskController _taskController = Get.find();
  final _controller = SuperTooltipController();
  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      showOnTap: true,
      showBarrier: true,
      borderColor: AppColors.primaryActionIconColorBlue,
      borderWidth: 2,
      arrowBaseWidth: 30,
      // minimumOutsideMargin: 10.w,
      constraints: BoxConstraints(
        maxWidth: 1.sw,
        maxHeight: 1.sh,
      ),
      popupDirection: TooltipDirection.up,
      controller: _controller,
      content: TaskTileActionContentWidget(
          taskId: widget.task.id, sController: _controller),
      onHide: _taskController.resetRowOptions,
      // child: Icon(
      //   // CupertinoIcons.flowchart,
      //   // CupertinoIcons.list_bullet_below_rectangle,
      //   // CupertinoIcons.rectangle_expand_vertical,
      //   // CupertinoIcons.layers_fill,
      //   // CupertinoIcons.ellipsis_vertical_circle,
      //   // CupertinoIcons.square_on_circle,
      //   // CupertinoIcons.square_stack_3d_down_right_fill,
      //   // CupertinoIcons.square_stack_3d_up_fill,
      //   // CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
      //   CupertinoIcons.ellipsis_vertical,

      //   color: Colors.black,
      //   size: 20.w,
      //   // color: AppColors.getPriorityColor(widget.task.priority),
      // ),

      child: Container(
        height: 20.w,
        width: 20.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: Colors.amber,
        ),
        child: Center(
          child: Icon(
            CupertinoIcons.ellipsis_vertical,
            size: 20.w,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class TaskTileActionContentWidget extends GetView<TaskController> {
  const TaskTileActionContentWidget(
      {super.key, required this.taskId, required this.sController});
  final String taskId;
  final SuperTooltipController sController;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getTaskRowOptions(taskId);
    });

    return Obx(() => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _getHeight(),
          child: Skeletonizer(
            enabled: controller.isTaskRowOptionsLoading.value,
            effect: PulseEffect(duration: Duration(milliseconds: 500)),
            enableSwitchAnimation: true,
            child: controller.taskRowOptions.isEmpty
                ? _emptyWidget()
                : Wrap(
                    spacing: 10.w,
                    runSpacing: 10.w,
                    children: List.generate(controller.taskRowOptions.length,
                        (index) => _rowTile(controller.taskRowOptions[index])),
                  ),
          ),
        ));
  }

  Widget _emptyWidget() => SizedBox(
        height: 40.h,
        width: 100.w,
        child: Center(
          child: CupertinoActivityIndicator(
              color: AppColors.chipCardWidgetColorBlue),
        ),
      );

  double _getHeight() {
    var length = controller.taskRowOptions.length;

    if (length == 0) return 50.h;

    int multiplier = (length / 3).ceil();
    return (multiplier * 50).h;
  }

  Widget _rowTile(TaskRowOptionModel taskRowOption) {
    return FlatButtonWidget(
      width: 110.w,
      label: controller.getTaskActionName(taskRowOption.action),
      color: controller.getTaskActionColor(taskRowOption.action),
      onTap: () {
        sController.hideTooltip();
      },
      isCompact: true,
    );
  }
}
