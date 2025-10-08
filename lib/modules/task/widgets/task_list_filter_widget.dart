import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_number_flow/flutter_number_flow.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:get/get.dart';

import 'widgets.dart';

class TaskListFilterWidget extends GetView<TaskController> {
  const TaskListFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(
        color: Colors.blueAccent,
        width: 1,
      ),
    );
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controller: controller.taskFilterExpandController,
        expansionAnimationStyle: AnimationStyle(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeIn,
        ),
        showTrailingIcon: false,
        dense: true,
        childrenPadding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 30.h,
                child: Obx(
                  () => Row(
                    spacing: 10.w,
                    //  runSpacing: 10.w,
                    mainAxisSize: MainAxisSize.min,
                    //  scrollDirection: Axis.horizontal,
                    children: [
                      ChipCardWidget(
                        label:
                            "Show task: ${controller.taskFilterChipShowTask.value}",
                        color: AppColors.baseBlue,
                        fontSize: 8.sp,
                      ),
                      ChipCardWidget(
                        label:
                            "Person: ${controller.taskFilterChipUserName.value}",
                        color: AppColors.chipCardWidgetColorViolet,
                        fontSize: 8.sp,
                      ),
                      ChipCardWidget(
                        label:
                            "TaskID: ${controller.taskFilterChipTaskId.value}",
                        color: AppColors.chipCardWidgetColorGreen,
                        fontSize: 8.sp,
                      ),
                      ChipCardWidget(
                        label:
                            "Priority: ${controller.taskFilterChipPriority.value}",
                        color: AppColors.chipCardWidgetColorRed,
                        fontSize: 8.sp,
                      ),
                    ],
                  ).skeletonLoading(controller.isTaskOverviewLoading.value),
                ),
              ),
            )),
            // 5.horizontalSpace,
            SizedBox(
                height: 25.h,
                child: VerticalDivider(
                  width: 3.w,
                  color: AppColors.primarySubTitleTextColorBlueGreyLight,
                  thickness: 1.2.w,
                )),
            // 7.horizontalSpace,

            5.horizontalSpace,
            Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // NumberFlow(
                  //   value: controller.taskList.length,
                  //   animationStyle: NumberFlowAnimation.slide,
                  //   duration: const Duration(milliseconds: 600),
                  //   textStyle: GoogleFonts.poppins(
                  //       fontSize: 20.sp, fontWeight: FontWeight.w500),
                  // ),
                  AnimatedFlipCounter(
                    value: controller.taskList.length,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    textStyle: GoogleFonts.poppins(
                        fontSize: 20.sp, fontWeight: FontWeight.w500),
                  ),

                  5.horizontalSpace,
                  Text(
                    "Tasks",
                    style: GoogleFonts.poppins(
                        fontSize: 10.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ).skeletonLoading(controller.isTaskOverviewLoading.value),
            )
          ],
        ),
        children: [
          Row(
            children: [
              Text(
                "Show Task *",
                style: GoogleFonts.poppins(
                    fontSize: 10.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          5.verticalSpace,
          PrimaryDropdownField(
            value: controller.taskFilterShowTask.value,
            items: controller.taskFilterShowTaskList,
            onChanged: (value) {
              if (value != null) {
                controller.taskFilterShowTask.value = value;
              }
            },
          ),
          10.verticalSpace,
          Row(
            children: [
              Text(
                "Person *",
                style: GoogleFonts.poppins(
                    fontSize: 10.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          5.verticalSpace,
          Obx(
            () => PrimaryDropdownField(
              value: controller.taskFilterUserName.value,
              items: controller.taskFilterUserNameList.value,
              onChanged: (value) {
                if (value != null) {
                  controller.taskFilterUserName.value = value;
                }
              },
            ),
          ),
          10.verticalSpace,
          Row(
            children: [
              Text(
                "Priority*",
                style: GoogleFonts.poppins(
                    fontSize: 10.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          5.verticalSpace,
          PrimaryDropdownField(
            value: controller.taskFilterPriority.value,
            items: controller.taskFilterPriorityList,
            onChanged: (value) {
              if (value != null) {
                controller.taskFilterPriority.value = value;
              }
            },
          ),
          10.verticalSpace,
          Row(
            children: [
              Text(
                "Task ID *",
                style: GoogleFonts.poppins(
                    fontSize: 10.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          5.verticalSpace,
          TextFormField(
            controller: controller.taskFilterTaskIdController,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              constraints: BoxConstraints(
                maxHeight: 40.h,
              ),
              filled: true,
              fillColor: Colors.white,
              border: borderStyle,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle.copyWith(
                borderSide:
                    const BorderSide(color: Colors.deepPurple, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          Row(
            children: [
              _actionButton("Reset", AppColors.primaryTitleTextColorBlueGrey,
                  () {
                controller.getTaskWithFilter(reset: true);
              }),
              Spacer(),
              _actionButton("Search", AppColors.chipCardWidgetColorBlue, () {
                controller.getTaskWithFilter();
              }),
            ],
          )
        ],
      ),
    );
  }

  _actionButton(String label, Color color, Function() onTap) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      height: 40.h,
      width: 90.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r), color: color.withAlpha(50)),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
