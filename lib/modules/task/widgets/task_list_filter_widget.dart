import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      child: Obx(
        () => ExpansionTile(
          controller: controller.taskFilterExpandController,
          showTrailingIcon: false,
          dense: true,
          childrenPadding:
              EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          title: Row(
            spacing: 10.w,
            children: [
              5.horizontalSpace,
              ChipCardWidget(label: "All Tasks", color: AppColors.baseBlue),
              ChipCardWidget(
                  label: "Amrithanath",
                  color: AppColors.chipCardWidgetColorViolet),
              ChipCardWidget(
                  label: "Open", color: AppColors.chipCardWidgetColorGreen),
              Spacer(),
              Text(
                "${controller.taskList.length} tasks",
                style: GoogleFonts.poppins(
                    fontSize: 10.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          children: [
            Row(
              children: [
                Text(
                  "Status *",
                  style: GoogleFonts.poppins(
                      fontSize: 10.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            5.verticalSpace,
            DropdownButtonFormField<String>(
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
              items: const [
                DropdownMenuItem(value: "pending", child: Text("Pending")),
                DropdownMenuItem(value: "done", child: Text("Done")),
              ],
              onChanged: (value) {},
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
            DropdownButtonFormField<String>(
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
              items: const [
                DropdownMenuItem(value: "john", child: Text("John")),
                DropdownMenuItem(value: "emma", child: Text("Emma")),
              ],
              onChanged: (value) {},
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
          ],
        ),
      ),
    );
  }
}
