import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:axpert_space/modules/active_list/widgets/active_list_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveListTaskListWidget extends GetView<ActiveListController> {
  const ActiveListTaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init();
    });
    return Expanded(
        child: Obx(
      () => Visibility(
        visible: controller.activeTaskMap.keys.isNotEmpty,
        child: ListView(
          controller: controller.taskListScrollController,
          // padding: EdgeInsets.only(top: 20),
          physics: BouncingScrollPhysics(),
          children: List.generate(
            controller.activeTaskMap.keys.length,
            (index) {
              var key = controller.activeTaskMap.keys.toList()[index];
              var currentList = controller.activeTaskMap[key] ?? [];

              return ActiveListListTileWidget(
                  title: key, currentList: currentList);
            },
          ),
        ),
      ),
    ));
  }
}
