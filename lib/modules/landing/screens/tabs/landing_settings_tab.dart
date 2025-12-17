import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/landing/landing.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../common/widgets/flat_button_widget.dart';
import '../../../../core/core.dart';
import '../../../settings/settings.dart';

class LandingSettingsTab extends GetView<LandingController> {
  const LandingSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationController n = Get.find();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        // titleSpacing: 0,
        // leading: LandingDrawerIconWidget(),
        title: Text("⚙️ Settings"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          20.verticalSpace,
          SettingsTabHeaderWidget(),
          10.verticalSpace,
          Obx(
            () => SettingsSwitchTile(
                onChanged: (_) {
                  controller.onNotificationTileClick();
                },
                icon: Icon(EvaIcons.bell),
                label: "Notification",
                value: n.showNotify.value),
          ),
          SettingsSwitchTile(
              icon: Icon(Icons.track_changes_rounded),
              label: "App Logs",
              value: true),
          SettingsTile(
            icon: Icon(Icons.language),
            label: "Language",
            onTap: () {},
            trailingIcon: Icon(
              Icons.chevron_right_rounded,
            ),
          ),
          SettingsTile(
            icon: Icon(Icons.share_rounded),
            label: "Share App",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icon(Icons.privacy_tip_outlined),
            label: "Privacy Policy",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icon(Icons.insert_page_break_rounded),
            label: "Terms and Conditions",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icon(Icons.cookie_outlined),
            label: "Cookies Policy",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icon(Icons.mail_outlined),
            label: "Contact",
            onTap: () {},
          ),
          SettingsTile(
              onTap: () {},
              icon: Icon(Icons.chat_bubble_outline_outlined),
              label: "Feedback"),
          SettingsTile(
            icon: Icon(
              Clarity.logout_line,
              color: AppColors.baseRed,
            ),
            label: "Logout",
            color: AppColors.baseRed,
            onTap: () {
              _showLogOutDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showLogOutDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please Confirm",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.baseRed,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Lottie.asset(
                reverse: true,
                'assets/lotties/logout.json',
              ),
              Text(
                "Are you sure you want to log out?",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              Obx(() => AnimatedSwitcherPlus.flipX(
                    duration: Duration(milliseconds: 400),
                    child: controller.isSignOutLoading.value
                        ? _loadingWidget()
                        : Row(
                            key: ValueKey("signout-button"),
                            children: [
                              Expanded(
                                child: FlatButtonWidget(
                                  width: 100.w,
                                  label: "Close",
                                  color: AppColors.primaryActionColorDarkBlue,
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              // Spacer(),
                              20.horizontalSpace,
                              Expanded(
                                child: FlatButtonWidget(
                                  width: 100.w,
                                  label: "Log Out",
                                  color: AppColors.chipCardWidgetColorRed,
                                  onTap: controller.startLogOut,
                                ),
                              ),
                            ],
                          ),
                  ))
            ],
          ),
        ),
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }

  Container _loadingWidget() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
            color: AppColors.baseRed.withAlpha(50),
            borderRadius: BorderRadius.circular(10.r)),
        child: Center(
          child: Text(
            "Loging you out.....",
            style:
                AppStyles.actionButtonStyle.copyWith(color: AppColors.baseRed),
          ),
        ));
  }
}
