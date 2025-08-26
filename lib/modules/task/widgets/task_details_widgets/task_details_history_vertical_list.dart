import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/modules.dart';
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
          var history = controller.taskHistoryList[index];
          var hideToUser =
              history.status.toString().toLowerCase().contains("accepted");
          return _historyTile(history, hideToUser, index);
          // return Container(color: Colors.amber, height: 20.h);
        });
  }

  _historyTile(history, hideToUser, index) => SizedBox(
        height: 140.h,
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
                        Text(
                          history.modifiedon,
                          style: AppStyles.taskHistoryUserNameStyle,
                        ),
                      ],
                    ),
                  ),
                  // 20.verticalSpace,
                  5.verticalSpace,
                  ChipCardWidget(
                      label: history.status,
                      color: AppColors.getHistoryColor(history.status)),
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
                          HistoryToolTipWidget(
                            history: history,
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
}
