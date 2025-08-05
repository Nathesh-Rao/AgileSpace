import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';

class TaskDetailsCommentsWidget extends GetView<TaskController> {
  const TaskDetailsCommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.secondaryButtonBorderColorGrey,
          )),
      child: SizedBox(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.chat_bubble_2_fill,
                    size: 12.w,
                    color: Color(0xffDDACF5),
                  ),
                  10.horizontalSpace,
                  Text(
                    "Add Comments",
                    style: GoogleFonts.poppins(
                        fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primaryActionColorDarkBlue),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9).withAlpha(100),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration.collapsed(
                    hintText: '',
                  ),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
