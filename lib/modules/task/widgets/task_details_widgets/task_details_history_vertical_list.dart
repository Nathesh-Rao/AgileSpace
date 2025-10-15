import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:axpert_space/modules/task/models/task_history_model.dart';
import 'package:axpert_space/modules/task/widgets/task_details_widgets/task_details_description_widget.dart';
import 'package:axpert_space/modules/task/widgets/widgets.dart';
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
          return _historyTile1(index, controller.taskHistoryList.length);
          // return Container(color: Colors.amber, height: 20.h);
        });
  }

  _historyTile1(int index, int maxCount) {
    var history = controller.taskHistoryList[index];
    var hideToUser =
        (history.status.toString().toLowerCase().contains("accepted") ||
            history.status.toString().toLowerCase().contains("completed"));
    var isLast = index == maxCount - 1;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left line with arrow
          Column(
            children: [
              // top dot
              CircleAvatar(
                radius: 10.w,
                backgroundColor: AppColors.getHistoryColor(history.status),
                child: Text(
                  "${index + 1}",
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),

              // vertical line
              if (!isLast)
                Expanded(
                  child: Transform.translate(
                    offset: Offset(0, 3),
                    child: Container(
                      width: 1,
                      color: AppColors.getHistoryColor(history.status),
                    ),
                  ),
                ),

              // // down arrow
              if (!isLast)
                Icon(
                  Icons.arrow_downward,
                  color: AppColors.getHistoryColor(history.status),
                  size: 16,
                ),
            ],
          ),

          SizedBox(width: 8),

          // right content
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      !hideToUser
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 5.w,
                              children: [
                                Image.asset(
                                  "assets/icons/common/arrow_line_icon.png",
                                  color: Colors.black,
                                  width: 60.w,
                                ),
                                Text(
                                  history.toUser,
                                  style: AppStyles.taskHistoryUserNameStyle,
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      Spacer(),
                    ],
                  ),
                ),
                5.verticalSpace,
                Row(
                  children: [
                    ChipCardWidget(
                        label: history.status,
                        color: AppColors.getHistoryColor(history.status)),
                    Spacer(),
                    Text(
                      DateUtilsHelper.formatDateTimeForHistory(
                          history.modifiedon),
                      // history.modifiedon,
                      style: AppStyles.taskHistoryUserNameStyle.copyWith(
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !history.message.isEmpty
                        ? Text(
                            "Comments :",
                            style: AppStyles.taskHistoryUserNameStyle,
                          )
                        : SizedBox(),
                    Text(
                      history.message,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Color(0xffA2A2A2),
                        fontSize: 10.sp,
                      ),
                    ),
                    5.verticalSpace,
                  ],
                ),
                10.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }

  _historyTile(int index, int maxCount) {
    var history = controller.taskHistoryList[index];
    var hideToUser =
        (history.status.toString().toLowerCase().contains("accepted") ||
            history.status.toString().toLowerCase().contains("completed"));
    var isLast = index == maxCount - 1;
    return SizedBox(
      height: 150.h,
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 10.w,
                backgroundColor: AppColors.getHistoryColor(history.status),
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
                  color: AppColors.getHistoryColor(history.status),
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      !hideToUser
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 5.w,
                              children: [
                                Image.asset(
                                  "assets/icons/common/arrow_line_icon.png",
                                  color: Colors.black,
                                  width: 60.w,
                                ),
                                Text(
                                  history.toUser,
                                  style: AppStyles.taskHistoryUserNameStyle,
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      Spacer(),
                    ],
                  ),
                ),
                // 20.verticalSpace,
                5.verticalSpace,
                Row(
                  children: [
                    ChipCardWidget(
                        label: history.status,
                        color: AppColors.getHistoryColor(history.status)),
                    Spacer(),
                    Text(
                      DateUtilsHelper.formatDateTimeForHistory(
                          history.modifiedon),
                      // history.modifiedon,
                      style: AppStyles.taskHistoryUserNameStyle.copyWith(
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,

                // 5.verticalSpace,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !history.message.isEmpty
                        ? Text(
                            "Comments :",
                            style: AppStyles.taskHistoryUserNameStyle,
                          )
                        : SizedBox(),
                    Row(
                      children: [
                        Flexible(
                          child: HistoryToolTipWidget(
                            history: history,
                          ),
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
  }
}
