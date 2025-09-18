import 'package:axpert_space/common/widgets/empty_widget.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/notification_widget.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        // foregroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: Get.back,
          child: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Notification",
          style: AppStyles.appBarTitleTextStyle.copyWith(color: Colors.white),
        ),
        actions: [
          Text(
            "clear all",
            style: AppStyles.appBarTitleTextStyle
                .copyWith(color: Colors.white, fontSize: 12.sp),
          ),
          10.horizontalSpace,
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: 1.sw,
            height: 130.h,
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/common/notification_header.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Expanded(
              child: Obx(
            () => controller.list.isEmpty
                ? Center(
                    child: EmptyWidget(
                    label: "No norification found",
                  ))
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    // itemBuilder: (context, index) => NotificationWidget(
                    //     message: FirebaseMessageModel(
                    //         "Thursday's Check-in Awaits!",
                    //         "Your attendance summary needs review. Don’t miss it! Your attendance summary needs review. Don’t miss it!")),
                    itemBuilder: (context, index) => controller.list[index],
                    separatorBuilder: (context, index) => 10.verticalSpace,
                    // itemCount: 1,
                    itemCount: controller.list.length,
                  ),
          ))
        ],
      ),
    );
  }
}
