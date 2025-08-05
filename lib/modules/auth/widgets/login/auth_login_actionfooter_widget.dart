import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';

class AuthLoginActionFooterWidget extends GetView<AuthController> {
  const AuthLoginActionFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Transform.scale(
            scale: 12 / 18, // default checkbox is ~18x18, so scale down
            child: Checkbox(
              activeColor: Color(0xff5BBBA9),
              value: true,
              onChanged: (bool? newValue) {},
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              side: const BorderSide(width: 2, color: Colors.black), // optional
            ),
          ),
          Text(
            "Remember Me?",
            style: AppStyles.actionButtonStyle,
          ),
          Spacer(),
          Text(
            "Forgot Password?",
            style: AppStyles.actionButtonStyle,
          ),
        ],
      ),
    );
  }
}
