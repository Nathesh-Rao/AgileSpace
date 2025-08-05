import 'dart:math';

import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';

class TaskDetailsHistoryVerticalListWidget extends GetView<TaskController> {
  const TaskDetailsHistoryVerticalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: controller.taskHistoryList.length,
        itemBuilder: (context, index) {
          var history = controller.taskHistoryList[index];

          return SizedBox(
            height: 140.h,
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10.w,
                      backgroundColor: AppColors.getHistoryColor(history.actionTook),
                      child: Text(
                        "${index + 1}",
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    Flexible(
                      child: Image.asset(
                        "assets/icons/common/arrow_line_vertical_icon.png",
                        color: AppColors.getHistoryColor(history.actionTook),
                        // height: 95.h,
                      ),
                    ),
                    5.verticalSpace,
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Row(
                          spacing: 5.w,
                          children: [
                            1.horizontalSpace,
                            Text(
                              history.fromUser,
                              style: AppStyles.taskHistoryUserNameStyle,
                            ),
                            Image.asset(
                              "assets/icons/common/arrow_line_icon.png",
                              color: Colors.black,
                              width: 60.w,
                            ),
                            Text(
                              history.toUser,
                              style: AppStyles.taskHistoryUserNameStyle,
                            ),
                            Spacer(),
                            Text(
                              history.date,
                              style: AppStyles.taskHistoryUserNameStyle,
                            ),
                          ],
                        ),
                      ),
                      // 20.verticalSpace,
                      ChipCardWidget(label: history.actionTook, color: AppColors.getHistoryColor(history.actionTook)),
                      // 5.verticalSpace,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Comments :",
                            style: AppStyles.taskHistoryUserNameStyle,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  history.message,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffA2A2A2),
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                          5.verticalSpace,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
