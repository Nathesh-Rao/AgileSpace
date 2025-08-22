import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common.dart';
import '../../../core/core.dart';
import '../../../routes/app_routes.dart';
import '../models/models.dart';

class TaskListListTileWidget extends StatelessWidget {
  const TaskListListTileWidget({super.key, required this.taskModel});
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    taskModel.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryActionColorDarkBlue,
                    ),
                  ),
                ),
                20.horizontalSpace,
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
              ],
            ),
            5.verticalSpace,
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
            12.verticalSpace,
            Row(
              children: [
                Row(
                  spacing: 10.w,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChipCardWidget(label: "UI/UX Design", fontSize: 8.sp, color: AppColors.chipCardWidgetColorViolet),
                    ChipCardWidget(
                        label: taskModel.priority, fontSize: 8.sp, color: AppColors.getPriorityColor(taskModel.priority)),
                  ],
                ),
                Spacer(),
                Text(
                  "TID : ${taskModel.id}",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleTextColorBlueGrey,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                Flexible(
                  child: ParticipantAvatarStackWidget(
                    maxVisible: 3,
                    avatarUrls: [],
                    participantCount: taskModel.participantCount,
                  ),
                ),
                ChipCardWidget(label: taskModel.status, fontSize: 8.sp, color: AppColors.getStatusColor(taskModel.status)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
