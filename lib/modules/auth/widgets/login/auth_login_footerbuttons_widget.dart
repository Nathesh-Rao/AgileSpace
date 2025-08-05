import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import '../../../../common/common.dart';

class AuthLoginFooterButtonsWidget extends GetView<AuthController> {
  const AuthLoginFooterButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => PrimaryButtonWidget(
              onPressed: controller.onLoginContinueButtonClick,
              label: "Continue",
              isLoading: controller.isLoginLoading.value,
            )),
        20.verticalSpace,
        Row(
          children: [
            Flexible(
                child: SecondaryButtonWidget(
                    margin: EdgeInsets.only(left: 25, right: 10), onPressed: () {}, child: Brand(Brands.google, size: 24.w))),
            Flexible(
                child: SecondaryButtonWidget(
                    margin: EdgeInsets.only(left: 10, right: 25), onPressed: () {}, child: Icon(Bootstrap.phone, size: 24.w))),
          ],
        ),
      ],
    );
  }
}
