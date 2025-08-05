import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';
import '../../controllers/auth_controller.dart';

class AuthOTPActionFooterWidget extends GetView<AuthController> {
  const AuthOTPActionFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: [
          Transform.scale(
              scale: 12 / 18, // default checkbox is ~18x18, so scale down
              child: Icon(
                CupertinoIcons.time_solid,
                color: Color(0xff5BBBA9),
              )),
          Obx(
            () => Text(
              "${controller.timeLeft.value} min",
              style: AppStyles.actionButtonStyle,
            ),
          ),
          Spacer(),
          Obx(
            () => TextButton(
                onPressed: controller.isTimerActive.value ? null : controller.callResendOTP,
                style: TextButton.styleFrom(
                  textStyle: AppStyles.actionButtonStyle,
                ),
                child: Text(
                  "Resend OTP",
                )),
          )
        ],
      ),
    );
  }
}
