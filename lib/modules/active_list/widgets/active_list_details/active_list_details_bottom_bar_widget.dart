import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/flat_button_widget.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_details_controller.dart';
import 'package:axpert_space/modules/active_list/widgets/active_list_details/active_list_details_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveListDetailsBottomBarWidget
    extends GetView<ActiveListDetailsController> {
  const ActiveListDetailsBottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Visibility(
          visible:
              controller.selected_processFlow_taskType.toUpperCase() != "MAKE",
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.decelerate,
            height: controller.isTaskDetailsRowOptionsExpanded.value
                ? _getHeight()
                : 80.h,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2)),
              ],
            ),
            child: Obx(
              () {
                var actionList = _generateActionList();
                if (actionList.length.isOdd) {
                  actionList.add(((1.sw / 2) - 30.w).horizontalSpace);
                }

                return Wrap(
                  alignment: WrapAlignment.spaceAround,
                  runAlignment: WrapAlignment.start,
                  spacing: 10.w,
                  runSpacing: 15.h,
                  children: actionList,
                ).skeletonLoading(controller.isActiveListDetailsLoading.value);
              },
            ),
          ),
        );
      },
    );
  }

  double _getHeight() {
    var actionList = _generateActionList();
    var length = actionList.length;
    if (length == 0) return 80.h;

    int multiplier = (length / 2).ceil();
    return (multiplier * 80).h;
  }

  Widget _rowTile(
      {required String label,
      required Color color,
      required Function() onTap}) {
    return FlatButtonWidget(
      width: (1.sw / 2) - 30.w,
      label: label,

      color: color,
      onTap: onTap,
      // isCompact: true,
    );
  }

  List<Widget> _generateActionList() {
    if (controller.pendingTaskModel != null) {
      if (controller.pendingTaskModel!.tasktype.toUpperCase() == "CHECK") {
        return _generateCheckList();
      }
      if (controller.pendingTaskModel!.tasktype.toUpperCase() == "APPROVE") {
        return _generateApproveList();
      }
    }

    return [];
  }

  List<Widget> _generateCheckList() {
    List<Widget> list = [];
    list.add(widgetCheckButton());
    if (controller.pendingTaskModel!.returnable.toUpperCase() == "T") {
      list.add(widgetReturnButton());
    }
    if (controller.pendingTaskModel!.allowsendflg.toUpperCase() == "2" ||
        controller.pendingTaskModel!.allowsendflg.toUpperCase() == "3" ||
        controller.pendingTaskModel!.allowsendflg.toUpperCase() == "4") {
      list.add(widgetSendButton());
    }
    list.add(widgetViewButton());
    list.add(widgetHistoryButton());
    return list;
  }

  Widget widgetCheckButton() {
    return _rowTile(
        label: "Check",
        color: AppColors.chipCardWidgetColorGreen,
        onTap: () {
          _openDialog(
            "Check",
            AppColors.chipCardWidgetColorGreen,
          );
        });
  }

  Widget widgetReturnButton() {
    return _rowTile(
        label: "Return",
        color: AppColors.brownRed,
        onTap: () {
          _openDialog(
            "Return",
            AppColors.brownRed,
          );
        });
  }

  Widget widgetSendButton() {
    return _rowTile(
        label: "Send",
        color: AppColors.baseYellow,
        onTap: () {
          _openDialog(
            "Send",
            AppColors.baseYellow,
          );
        });
  }

  Widget widgetViewButton() {
    return _rowTile(
        label: "View",
        color: AppColors.chipCardWidgetColorViolet,
        onTap: () {
          _openDialog(
            "View",
            AppColors.chipCardWidgetColorViolet,
          );
        });
  }

  Widget widgetHistoryButton() {
    return _rowTile(
        label: "History",
        color: AppColors.baseBlue,
        onTap: () {
          _openDialog(
            "History",
            AppColors.baseBlue,
          );
        });
  }

  List<Widget> _generateApproveList() {
    List<Widget> list = [];
    list.add(widgetApproveButton());
    list.add(widgetRejectButton());
    if (controller.pendingTaskModel!.returnable.toUpperCase() == "T") {
      list.add(widgetReturnButton());
    }
    if (controller.pendingTaskModel!.allowsendflg.toUpperCase() == "2" ||
        controller.pendingTaskModel!.allowsendflg.toUpperCase() == "3" ||
        controller.pendingTaskModel!.allowsendflg.toUpperCase() == "4") {
      list.add(widgetSendButton());
    }
    list.add(widgetViewButton());
    list.add(widgetHistoryButton());
    return list;
  }

  Widget widgetApproveButton() {
    return _rowTile(
        label: "Approve",
        color: AppColors.chipCardWidgetColorGreen,
        onTap: () {
          _openDialog(
            "Approve",
            AppColors.chipCardWidgetColorGreen,
          );
        });
  }

  Widget widgetRejectButton() {
    return _rowTile(
        label: "Reject",
        color: AppColors.baseRed,
        onTap: () {
          _openDialog("Reject", AppColors.baseRed);
        });
  }

  _openDialog(String dlgType, Color color) {
    controller.comments.text = "";
    controller.errCom.value = "";
    Get.dialog(
        barrierDismissible: false,
        ActiveListDetailsDialogWidget(dlgType: dlgType, color: color));
  }
}
