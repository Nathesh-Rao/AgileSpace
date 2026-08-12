import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/permissions/controllers/permissions_controller.dart';
import '../../../core/core.dart';

class PermissionNotificationScreen extends GetView<PermissionsController> {
  const PermissionNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Column(
        children: [
          Text(
            "Notifications",
            style: AppStyles.onboardingTitleTextStyle,
          ),
          Spacer(),
          SlideInUp(
            from: 40,
            child: Image.asset(
              controller.permissionNotificationImage,
              width: 300.w,
            ),
          ),
          Spacer(),
          SlideInUp(
            from: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t miss out",
                  style: AppStyles.onboardingTitleTextStyle,
                ),
                Text(
                  "Never miss any important updates\nor notifications",
                  textAlign: TextAlign.center,
                  style: AppStyles.onboardingSubTitleTextStyle,
                ),
              ],
            ),
          ),
          40.verticalSpace,
          SlideInUp(
            from: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButtonWidget(onPressed: controller.onEnableNotificationButtonClick, label: "Enable Notification"),
                TextButton(
                    onPressed: controller.onAnotherTimeNotificationButtonClick,
                    child: Text(
                      "another time",
                      style: AppStyles.textButtonStyle,
                    )),
              ],
            ),
          ),
          40.verticalSpace,
        ],
      ),
    );
  }
}
