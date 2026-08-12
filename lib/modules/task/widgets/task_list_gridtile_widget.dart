import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:axpert_space/modules/task/widgets/widgets.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';

class TaskListGridTileWidget extends GetView<TaskController> {
  const TaskListGridTileWidget({super.key, required this.taskModel});
  final TaskListModel taskModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.tasDetails, arguments: {"taskModel": taskModel});
      },
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: controller.highlightedText(
                      taskModel.caption,
                      GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryActionColorDarkBlue,
                      )),

                  //  Text(
                  //   taskModel.caption,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: GoogleFonts.poppins(
                  //     fontSize: 12.sp,
                  //     fontWeight: FontWeight.w600,
                  //     color: AppColors.primaryActionColorDarkBlue,
                  //   ),
                  // ),
                ),
                20.horizontalSpace,
                TaskTileActionButtonWidget(
                  task: taskModel,
                ),
                // Icon(Icons.more_vert_rounded)
              ],
            ),
            3.verticalSpace,
            controller.highlightedText(
              "TID : ${taskModel.id}",
              GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTitleTextColorBlueGrey,
              ),
            ),
            // Text(
            //   "TID : ${taskModel.id}",
            //   style: GoogleFonts.poppins(
            //     fontSize: 10,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.primaryTitleTextColorBlueGrey,
            //   ),
            // ),
            3.verticalSpace,
            Row(
              children: [
                Flexible(
                  child: Text(
                    taskModel.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondarySubTitleTextColorGreyLight,
                    ),
                  ),
                ),
                50.horizontalSpace,
              ],
            ),
            7.verticalSpace,
            Row(
              children: [
                Icon(
                  Icons.flag_circle,
                  color: AppColors.chipCardWidgetColorRed,
                  size: 8.w,
                ),
                5.horizontalSpace,
                Text(
                  StringUtils.formatDate(taskModel.dueDate.toString()),
                  style: GoogleFonts.poppins(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            10.verticalSpace,
            Wrap(
              spacing: 10.w,
              children: [
                ChipCardWidget(
                    label: taskModel.taskCategory,
                    color: AppColors.chipCardWidgetColorViolet),
                ChipCardWidget(
                    label: taskModel.priority,
                    color: AppColors.getPriorityColor(taskModel.priority)),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Flexible(
                  child: ParticipantAvatarStackWidget(
                    maxVisible: 3,
                    avatarUrls: [],
                    participantCount: taskModel.participantCount,
                  ),
                ),
                ChipCardWidget(
                    label: taskModel.status,
                    color: AppColors.getStatusColor(taskModel.status)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
