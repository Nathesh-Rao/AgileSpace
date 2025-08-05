import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../widgets/widget.dart';

class AuthOtpScreen extends GetView<AuthController> {
  const AuthOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onOtpScreenLoad();
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh - MediaQuery.of(context).viewPadding.vertical,
          child: Column(
            children: [
              Obx(() => Visibility(visible: controller.isOtpLoading.value, child: RainbowLoadingWidget())),
              // Spacer(),
              20.verticalSpace,
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "OTP",
                    style: AppStyles.onboardingTitleTextStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Text(
                      controller.otpMsg.value,
                      textAlign: TextAlign.center,
                      style: AppStyles.onboardingSubTitleTextStyle,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Image.asset(controller.otpHeaderImage, width: 280.w),
              45.verticalSpace,

              AuthOtpTextFieldWidget(),
              15.verticalSpace,

              AuthOTPActionFooterWidget(),
              30.verticalSpace,
              Obx(() => PrimaryButtonWidget(
                    onPressed: controller.onOtpLoginButtonClick,
                    label: "Login",
                    isLoading: controller.isOtpLoading.value,
                  )),
              20.verticalSpace,
              AuthOtpTermsTextWidget(),
              Spacer(),
            ],
          ),
        ),
      )),
    );
  }
}
