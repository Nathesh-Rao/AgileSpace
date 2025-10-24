import 'package:axpert_space/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';
import '../../../routes/app_routes.dart';
import '../models/models.dart';
import 'task_tile_action_button_widget.dart';

class TaskListSingleTileWidget extends StatelessWidget {
  const TaskListSingleTileWidget({super.key, required this.taskModel});
  final TaskListModel taskModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.tasDetails, arguments: {"taskModel": taskModel});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  spacing: 5.w,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      taskModel.project,
                      style: AppStyles.textButtonStyle.copyWith(
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      "Project",
                      style: AppStyles.textButtonStyle.copyWith(
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                TaskTileActionButtonWidget(
                  task: taskModel,
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Text(
                  "TID : ${taskModel.id}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleTextColorBlueGrey,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Flexible(
                  child: Text(
                    taskModel.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryActionColorDarkBlue,
                    ),
                  ),
                ),
                50.horizontalSpace,
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Icon(
                  Icons.flag,
                  size: 12.w,
                  color: AppColors.chipCardWidgetColorRed,
                ),
                5.horizontalSpace,
                Text(
                  StringUtils.formatDate(taskModel.dueDate.toString()),
                  style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primarySubTitleTextColorBlueGreyLight),
                )
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                Row(
                  spacing: 10.w,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChipCardWidget(
                        onMaxSize: true,
                        label: taskModel.taskCategory,
                        color: AppColors.chipCardWidgetColorViolet),
                    ChipCardWidget(
                        onMaxSize: true,
                        label: taskModel.priority,
                        color: AppColors.getPriorityColor(taskModel.priority)),
                  ],
                ),
                Spacer(),
              ],
            ),
            15.verticalSpace,
            Row(
              spacing: 20.w,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.chat_bubble_2_fill,
                      size: 12.w,
                      color: Color(0xffDDACF5),
                    ),
                    5.horizontalSpace,
                    Text(
                      "${taskModel.messageCount} Comments",
                      style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              AppColors.primarySubTitleTextColorBlueGreyLight),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Bootstrap.stack,
                      size: 12.w,
                      color: Color(0xff718EBF),
                    ),
                    5.horizontalSpace,
                    Text(
                      "${taskModel.attachmentCount} Attachments",
                      style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              AppColors.primarySubTitleTextColorBlueGreyLight),
                    )
                  ],
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Flexible(
                  child: Text(
                    taskModel.description,
                    maxLines: 3,
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
            15.verticalSpace,
            Row(
              children: [
                Flexible(
                  child: ParticipantAvatarStackWidget(
                    avatarSize: 35.w,
                    avatarUrls: [],
                    maxVisible: 3,
                    participantCount: taskModel.participantCount,
                  ),
                ),
                ChipCardWidget(
                    onMaxSize: true,
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
