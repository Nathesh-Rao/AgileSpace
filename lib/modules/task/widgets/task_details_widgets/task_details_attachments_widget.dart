import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:axpert_space/modules/task/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';

class TaskDetailsAttachmentsWidget extends GetView<TaskController> {
  const TaskDetailsAttachmentsWidget({super.key, required this.taskModel});
  final TaskListModel taskModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _getHeight(),
      // height: 170.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h, bottom: 5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.secondaryButtonBorderColorGrey,
          )),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Bootstrap.stack,
                size: 12.w,
                color: AppColors.chipCardWidgetColorViolet,
              ),
              10.horizontalSpace,
              Text(
                "${taskModel.attachmentCount} Attachments",
                style: GoogleFonts.poppins(
                    fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primaryActionColorDarkBlue),
              ),
              Spacer(),
              Icon(
                CupertinoIcons.add_circled_solid,
                size: 15.w,
                color: Color(0xff0D99FF),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: taskModel.attachmentCount,
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      minLeadingWidth: 0,
                      horizontalTitleGap: 0,
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "Title-$index",
                        style: AppStyles.textButtonStyle.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flag,
                            size: 12.w,
                            color: AppColors.chipCardWidgetColorRed,
                          ),
                          5.horizontalSpace,
                          Text(
                            "13 MB",
                            style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primarySubTitleTextColorBlueGreyLight),
                          )
                        ],
                      ),
                      trailing: Icon(
                        CupertinoIcons.arrow_down_circle,
                        size: 16.w,
                        color: Color(0xff0D99FF),
                      ),
                    )),
          )
        ],
      ),
    );
  }

  _getHeight() {
    switch (taskModel.attachmentCount) {
      case 0:
        return 50.h;
      case 1:
        return 100.h;
      case 2:
        return 150.h;
      default:
        return 170.h;
    }
  }
}
