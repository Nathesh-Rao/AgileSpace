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
        Obx(
          () => AuthTextFieldWidget(
            readOnly: controller.isPWD_auth.value,
            errorText: controller.errUserName.value,
            controller: controller.userNameController,
            label: "Username",
            hintText: "",
            prefixIcon: Icon(
              CupertinoIcons.profile_circled,
              color: AppColors.primaryTitleTextColorBlueGrey,
              size: 20.w,
            ),
            suffixIcon: controller.isPWD_auth.value
                ? GestureDetector(
                    onTap: controller.toggleUserNameVisibility,
                    child: Icon(
                      Icons.lock,
                      color: AppColors.primaryTitleTextColorBlueGrey,
                      size: 20.w,
                    ),
                  )
                : null,
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
                    errorText: controller.errPassword.value,
                    controller: controller.userPasswordController,
                    focusNode: controller.passwordFocus,
                    obscureText: controller.showPassword.value,
                    label: "Password",
                    hintText: "enter your password",
                    prefixIcon: Icon(
                      AntDesign.key_outline,
                      color: AppColors.primaryTitleTextColorBlueGrey,
                      size: 20.w,
                    ),

                    suffixIcon: GestureDetector(
                      onTap: () {
                        controller.showPassword.toggle();
                      },
                      child: FlipInY(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                        key: ValueKey(controller.showPassword.value),
                        child: Icon(
                          !controller.showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: !controller.showPassword.value
                              ? AppColors.chipCardWidgetColorRed
                              : AppColors.chipCardWidgetColorGreen,
                          size: 20.w,
                        ),
                      ),
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
