import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/pending_process_flow_model.dart';

class ActiveListDetailsHistoryWidget
    extends GetView<ActiveListDetailsController> {
  const ActiveListDetailsHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
          height: 55.h,
          width: double.infinity,
          color: Color(0xffFAFAFA),
          child: ListView.separated(
              // shrinkWrap: true,
              padding: EdgeInsets.all(15),
              itemCount: controller.processFlowList.length,
              scrollDirection: Axis.horizontal,

              // scrollDirection: controller.showHistoryContent.value ? Axis.vertical : Axis.horizontal,
              separatorBuilder: (context, index) {
                PendingProcessFlowModel flow =
                    controller.processFlowList[index];
                return Icon(
                  Icons.arrow_right_alt_sharp,
                  color: _getColor(flow),
                );
              },
              itemBuilder: (context, index) {
                return _historyTile(controller.processFlowList[index]);
              })).skeletonLoading(controller.isActiveListDetailsLoading.value),
    );
  }

  Widget _historyTile(PendingProcessFlowModel flow) {
    return InkWell(
      onTap: () {
        controller.onProcessFlowItemTap(flow);
        if (flow.taskid.toString().toLowerCase() != 'null' &&
            flow.taskid.toString() != controller.selectedTaskID) {
          controller.fetchDetails(
              hasArgument: true, pendingProcessFlowModel: flow);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10.w,
            backgroundColor: _getColor(flow),
            child: Text(
              double.parse(flow.indexno).toInt().toString(),
              style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  // color: Colors.white,
                  color: _getIconTextColor(flow)),
            ),
          ),
          5.horizontalSpace,
          Text(
            flow.taskname,
            style: AppStyles.taskHistoryUserNameStyle.copyWith(
              color: _getTextColor(flow),
            ),
          ),
          5.horizontalSpace,
        ],
      ),
    );
  }

  _getColor(PendingProcessFlowModel flow) {
    return (flow.taskstatus.toLowerCase() == 'made' ||
            flow.taskstatus.toLowerCase() == 'approved' ||
            flow.taskstatus.toLowerCase() == 'approve')
        ? AppColors.chipCardWidgetColorGreen
        : flow.taskstatus.toLowerCase() == 'active'
            ? AppColors.baseYellow
            : flow.taskstatus.toLowerCase() == 'rejected'
                ? AppColors.baseRed
                : AppColors.grey;
  }

  _getIconTextColor(PendingProcessFlowModel flow) {
    return (flow.taskstatus.toLowerCase() == 'made' ||
            flow.taskstatus.toLowerCase() == 'approved' ||
            flow.taskstatus.toLowerCase() == 'rejected' ||
            flow.taskstatus.toLowerCase() == 'active')
        ? Colors.white
        : AppColors.primarySubTitleTextColorBlueGreyLight;
  }

  _getTextColor(PendingProcessFlowModel flow) {
    return (controller.selectedTaskID == flow.taskid)
        ? AppColors.primaryActionColorDarkBlue
        : AppColors.text2;
  }
}
