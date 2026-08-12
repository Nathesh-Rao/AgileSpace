import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:axpert_space/modules/task/widgets/task_details_widgets/task_details_description_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import 'task_details_history_switch_widget.dart';
import 'task_details_last_action_widget.dart';

class TaskDetailsTaskInfoWidget extends StatelessWidget {
  const TaskDetailsTaskInfoWidget({super.key, required this.taskModel});
  final TaskListModel taskModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 12.h),
      margin: EdgeInsets.only(bottom: 25.h, left: 18.w, right: 18.w, top: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  taskModel.caption,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryActionColorDarkBlue,
                  ),
                ),
              ),
              30.horizontalSpace,
              TaskDetailsHistorySwitchWidget(),
            ],
          ),
          5.verticalSpace,
          Row(
            children: [
              ChipCardWidget(onMaxSize: true, label: taskModel.status, color: AppColors.getStatusColor(taskModel.status)),
              Spacer(),
              ChipCardWidget(onMaxSize: true, label: taskModel.priority, color: AppColors.getPriorityColor(taskModel.priority)),
            ],
          ),
          5.verticalSpace,
          TaskDetailsLastActionWidget(),
          10.verticalSpace,
          Row(
            children: [
              Text(
                "Created On : ",
                style: AppStyles.textButtonStyle.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.flag,
                size: 12.w,
                color: AppColors.chipCardWidgetColorGreen,
              ),
              5.horizontalSpace,
              Text(
                StringUtils.formatDate(taskModel.createdOn.toString()),
                style: GoogleFonts.poppins(
                    fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primarySubTitleTextColorBlueGreyLight),
              )
            ],
          ),
          10.verticalSpace,
          Row(
            children: [
              Text(
                "Due On : ",
                style: AppStyles.textButtonStyle.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.flag,
                size: 12.w,
                color: AppColors.chipCardWidgetColorRed,
              ),
              5.horizontalSpace,
              Text(
                StringUtils.formatDate(taskModel.dueDate.toString()),
                style: GoogleFonts.poppins(
                    fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primarySubTitleTextColorBlueGreyLight),
              )
            ],
          ),
          10.verticalSpace,
          Builder(builder: (context) {
            var isProjectInactive = taskModel.project.toLowerCase().contains("na");
            var isCustomerInactive = taskModel.customer.toLowerCase().contains("na");
            var isPartnerInactive = taskModel.partner.toLowerCase().contains("na");
            var inactiveColor = AppColors.grey7;
            getFullForm(String val) {
              if (val.toLowerCase().contains("na")) {
                return "Info not available";
              }
              return val;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 5.h,
              children: [
                Row(
                  spacing: 5.w,
                  children: [
                    Text(
                      "Project :",
                      style: AppStyles.textButtonStyle.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isProjectInactive ? inactiveColor : null,
                      ),
                    ),
                    Text(
                      getFullForm(taskModel.project),
                      style: AppStyles.textButtonStyle.copyWith(
                        fontSize: 13.sp,
                        color: isProjectInactive ? inactiveColor : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 5.w,
                  children: [
                    Text(
                      "Customer :",
                      style: AppStyles.textButtonStyle.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isCustomerInactive ? inactiveColor : null,
                      ),
                    ),
                    Text(
                      getFullForm(taskModel.customer),
                      style: AppStyles.textButtonStyle.copyWith(
                        fontSize: 13.sp,
                        color: isCustomerInactive ? inactiveColor : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 5.w,
                  children: [
                    Text(
                      "Partner :",
                      style: AppStyles.textButtonStyle.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isPartnerInactive ? inactiveColor : null,
                      ),
                    ),
                    Text(
                      getFullForm(taskModel.partner),
                      style: AppStyles.textButtonStyle.copyWith(
                        fontSize: 13.sp,
                        color: isPartnerInactive ? inactiveColor : null,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
          16.verticalSpace,
          ParticipantAvatarStackWidget(
            avatarSize: 35.w,
            avatarUrls: [],
            maxVisible: 3,
            participantCount: taskModel.participantCount,
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
                        fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primarySubTitleTextColorBlueGreyLight),
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
                        fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primarySubTitleTextColorBlueGreyLight),
                  )
                ],
              ),
            ],
          ),
          10.verticalSpace,
          TaskDetailsDescriptionWidget(
            description: taskModel.description,
          ),
          15.verticalSpace,
          Row(
            children: [
              Row(
                spacing: 10.w,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChipCardWidget(onMaxSize: true, label: taskModel.taskCategory, color: AppColors.chipCardWidgetColorViolet),
                  // ChipCardWidget(
                  //   onMaxSize: true,
                  //   label: taskModel.priority,
                  //   color: AppColors.getPriorityColor(taskModel.priority),
                  // ),
                ],
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
