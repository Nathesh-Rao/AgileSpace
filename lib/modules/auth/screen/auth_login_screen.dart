import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import '../../../core/core.dart';
import '../widgets/widget.dart';

class AuthLoginScreen extends GetView<AuthController> {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh - MediaQuery.of(context).viewPadding.vertical,
            child: Column(
              children: [
                Obx(() => Visibility(
                    visible: controller.isLoginLoading.value,
                    child: RainbowLoadingWidget())),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: AppStyles.onboardingTitleTextStyle,
                    ),
                    Text(
                      "Create an account or Login to  Explore\nabout our app",
                      textAlign: TextAlign.center,
                      style: AppStyles.onboardingSubTitleTextStyle,
                    ),
                  ],
                ),
                Spacer(),
                Image.asset(controller.loginHeaderImage, width: 300.w),
                Spacer(flex: 2),
                AuthLoginTextFieldsWidget(),
                AuthLoginActionFooterWidget(),
                25.verticalSpace,
                AuthLoginFooterButtonsWidget(),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
