import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_list_gridview_page.dart';
import 'task_list_listview_page.dart';
import 'task_list_singleview_page.dart';

class TaskListPageBuilderWidget extends GetView<TaskController> {
  const TaskListPageBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadInitialData();
    });

    return Expanded(
        child: PageView.builder(
      onPageChanged: (index) {
        controller.taskListPageViewIndex.value = index;
      },
      // physics: NeverScrollableScrollPhysics(),
      controller: controller.taskListPageViewController,
      itemCount: 3,
      itemBuilder: (context, index) => _getPage(index),
    ));
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return TaskListGridviewPage();
      case 1:
        return TaskListSingleViewPage();
      case 2:
        return TaskListListviewPage();
      default:
        return Container();
    }
  }
}
