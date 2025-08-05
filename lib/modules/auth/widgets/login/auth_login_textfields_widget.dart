import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import '../../../../common/common.dart';
import '../../../../core/core.dart';

class AuthLoginTextFieldsWidget extends GetView<AuthController> {
  const AuthLoginTextFieldsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthTextFieldWidget(
          controller: controller.userNameController,
          label: "Email",
          hintText: "demo@email.com",
          prefixIcon: Icon(
            CupertinoIcons.mail,
            color: AppColors.primaryTitleTextColorBlueGrey,
            size: 20.w,
          ),
        ),
        25.verticalSpace,
        Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              final fade = FadeTransition(opacity: animation, child: child);
              return SizeTransition(
                sizeFactor: animation,
                axis: Axis.vertical,
                child: fade,
              );
            },
            child: controller.isPWD_auth.value
                ? AuthTextFieldWidget(
                    controller: controller.userPasswordController,
                    focusNode: controller.passwordFocus,
                    label: "Password",
                    hintText: "enter your password",
                    prefixIcon: Icon(
                      AntDesign.key_outline,
                      color: AppColors.primaryTitleTextColorBlueGrey,
                      size: 20.w,
                    ),
                    // focusNode: loginController.passwordFocus,
                    // obscureText: loginController.showPassword.value,
                    // controller: loginController.userPasswordController,
                  )
                : const SizedBox.shrink(key: ValueKey("empty")),
          ),
        ),
        25.verticalSpace,
      ],
    );
  }
}
