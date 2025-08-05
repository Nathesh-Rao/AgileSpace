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
    return Pinput(
      length: 4,
      defaultPinTheme: PinTheme(
        margin: EdgeInsets.symmetric(horizontal: 7.w),
        width: 60.w,
        height: 60.w,
        textStyle: TextStyle(fontSize: 20, color: Colors.black),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      focusedPinTheme: PinTheme(
        margin: EdgeInsets.symmetric(horizontal: 7.w),
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.otpFieldThemeColorGreen, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      submittedPinTheme: PinTheme(
        margin: EdgeInsets.symmetric(horizontal: 7.w),
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.otpFieldThemeColorGreen, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onCompleted: (pin) => print('Completed: $pin'),
    );
  }
}
