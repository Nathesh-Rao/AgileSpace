import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:axpert_space/modules/notifications/widgets/notification_types_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/notification_setion_block.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "clear all",
              style: AppStyles.appBarTitleTextStyle.copyWith(
                  color: AppColors.primaryActionColorDarkBlue, fontSize: 12.sp),
            ),
          ),
          10.horizontalSpace,
        ],
      ),
      body: Obx(() {
        var groups = controller.groupedNotifications;

        return Column(
          children: [
            20.verticalSpace,
            NotificationTypesWidget(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                children: [
                  if (groups["Today"]!.isNotEmpty)
                    NotificationSetionBlock("Today", groups["Today"]!),
                  if (groups["Yesterday"]!.isNotEmpty)
                    NotificationSetionBlock("Yesterday", groups["Yesterday"]!),
                  if (groups["Last 7 Days"]!.isNotEmpty)
                    NotificationSetionBlock(
                        "Last 7 Days", groups["Last 7 Days"]!),
                  if (groups["Older"]!.isNotEmpty)
                    NotificationSetionBlock("Older", groups["Older"]!),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
