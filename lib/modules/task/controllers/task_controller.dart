import 'package:axpert_space/modules/task/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final taskListPageViewIndex = 0.obs;
  final isTaskListLoading = false.obs;
  final taskListPageViewController = PageController();
  final taskList = [].obs;

  loadInitialData() async {
    int newPage = taskListPageViewController.page?.round() ?? 0;
    if (newPage != taskListPageViewIndex.value) {
      taskListPageViewIndex.value = newPage;
    }
    if (taskList.isNotEmpty) return;
    isTaskListLoading.value = true;
    taskList.value = TaskListModel.tempList;
    await Future.delayed(Duration(seconds: 3));
    isTaskListLoading.value = false;
  }

  onTaskListViewSwitchButtonClick() {
    int newIndex = (taskListPageViewIndex.value + 1) % 3;
    if (taskListPageViewIndex.value == 2 && newIndex == 0) {
      taskListPageViewController.jumpToPage(0);
    } else {
      taskListPageViewController.animateToPage(
        newIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
    taskListPageViewIndex.value = newIndex;
  }

  //TaskDetailsPage
  var taskHistoryList = [].obs;
  var isTaskDetailsLoading = false.obs;
  var showHistoryFlag = false.obs;
  var showHistoryContent = true.obs;
  TaskListModel? _lastLoadedTask;

  void onShowHistoryIconClick() {
    showHistoryFlag.toggle();
  }

  void onHistoryWidgetAnimationEndCallBack() {
    showHistoryContent.toggle();
  }

  void loadTaskDetails({required TaskListModel task}) async {
    if (_lastLoadedTask?.id == task.id) return;
    _lastLoadedTask = task;
    showHistoryFlag.value = false;
    isTaskDetailsLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    taskHistoryList.value = TaskHistoryModel.tempData[task.id.toString()] ?? [];
    isTaskDetailsLoading.value = false;
  }

  bool onTaskDetailsPullUpDownCallBack(ScrollNotification notification) {
    if (isTaskDetailsLoading.value) return true;

    if (notification.metrics.pixels < -150) {
      if (!showHistoryFlag.value) {
        onShowHistoryIconClick();
      }
    } else if (notification.metrics.pixels > notification.metrics.maxScrollExtent + 100) {
      if (showHistoryFlag.value) {
        onShowHistoryIconClick();
      }
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
