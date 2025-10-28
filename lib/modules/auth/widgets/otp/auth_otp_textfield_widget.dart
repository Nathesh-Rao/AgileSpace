import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class AuthOtpTextFieldWidget extends GetView<AuthController> {
  const AuthOtpTextFieldWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShakeX(
              duration: Duration(milliseconds: 500),
              key: ValueKey(controller.otpErrorText),
              animate: controller.otpErrorText.isNotEmpty,
              child: Pinput(
                length: int.parse(controller.otpChars.value),
                controller: controller.otpFieldController,
                defaultPinTheme: PinTheme(
                  margin: EdgeInsets.symmetric(horizontal: 7.w),
                  width: 60.w,
                  height: 60.w,
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: controller.otpErrorText.value.isNotEmpty ? AppColors.chipCardWidgetColorRed : Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  margin: EdgeInsets.symmetric(horizontal: 7.w),
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: controller.otpErrorText.value.isNotEmpty ? AppColors.chipCardWidgetColorRed : Colors.grey,
                        width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  margin: EdgeInsets.symmetric(horizontal: 7.w),
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: controller.otpErrorText.value.isNotEmpty
                            ? AppColors.chipCardWidgetColorRed
                            : AppColors.otpFieldThemeColorGreen,
                        width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onCompleted: (pin) {
                  controller.callVerifyOTP();
                },
              ),
            ),
            15.verticalSpace,
            Obx(() => controller.otpErrorText.isNotEmpty
                ? ShakeX(
                    duration: Duration(milliseconds: 500),
                    child: ChipCardWidget(
                        borderRadius: 2, label: controller.otpErrorText.value, color: AppColors.chipCardWidgetColorRed))
                : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}



