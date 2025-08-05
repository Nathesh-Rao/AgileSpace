import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';
import 'task_list_switch_widget.dart';

class TaskSearchActionWidget extends GetView<TaskController> {
  const TaskSearchActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PrimarySearchFieldWidget(),
        IconButton(onPressed: () {}, icon: Icon(Icons.settings_input_composite_outlined)),
        TaskListSwitchWidget(),
        10.horizontalSpace,
      ],
    );
  }
}
