import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/core.dart';

class ActiveListBulkApproveCommentWidget extends GetView<ActiveListController> {
  const ActiveListBulkApproveCommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 105.h,
        width: double.infinity,
        // margin: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: AppColors.secondaryButtonBorderColorGrey,
            )),
        child: SizedBox(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                child: Row(
                  children: [
                    Text(
                      "Add Comments",
                      style: GoogleFonts.poppins(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textFieldMainTextColorBlueGrey),
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
                    controller: controller.bulkCommentController,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration.collapsed(
                      hintText: '',
                    ),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).skeletonLoading(controller.isBulkApprovelSubmitLoading.value),
    );
  }
}
