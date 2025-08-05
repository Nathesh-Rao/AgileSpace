import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/permissions/controllers/permissions_controller.dart';
import '../../../core/core.dart';

class PermissionLocationScreen extends GetView<PermissionsController> {
  const PermissionLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Column(
        children: [
          Text(
            "Location",
            style: AppStyles.onboardingTitleTextStyle,
          ),
          Spacer(),
          SlideInUp(
            from: 40,
            child: Image.asset(
              controller.permissionLocationImage,
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
                  "Stay in the loop",
                  style: AppStyles.onboardingTitleTextStyle,
                ),
                Text(
                  "Enable location to access all features\ndesigned around your needs.",
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
                PrimaryButtonWidget(onPressed: controller.onEnableLocationButtonClick, label: "Enable Location"),
                TextButton(
                    onPressed: controller.onAnotherTimeLocationButtonClick,
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
