import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../../settings/settings.dart';
import '../../widgets/widgets.dart';

class LandingSettingsTab extends StatelessWidget {
  const LandingSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
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
          SettingsSwitchTile(
              icon: Icon(EvaIcons.bell), label: "Notification", value: true),
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
              Get.offAllNamed(AppRoutes.splash);
            },
          ),
        ],
      ),
    );
  }
}
