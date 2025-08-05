import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingSettingsTab extends StatelessWidget {
  const LandingSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Settings"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: PrimaryButtonWidget(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.login);
                },
                label: "Sign Out"),
          )
        ],
      ),
    );
  }
}
