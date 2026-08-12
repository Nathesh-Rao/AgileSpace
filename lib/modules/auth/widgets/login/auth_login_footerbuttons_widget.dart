import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import '../../../../common/common.dart';
import '../../../../core/core.dart';

class AuthLoginFooterButtonsWidget extends GetView<AuthController> {
  const AuthLoginFooterButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => AnimatedSwitcher(
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
              child: !controller.isPWD_auth.value
                  ? PrimaryButtonWidget(
                      onPressed: controller.startLoginProcess,
                      label: "Continue",
                      isLoading: controller.isLoginLoading.value,
                    )
                  : PrimaryButtonWidget(
                      onPressed: controller.callSignInAPI,
                      label: _getLoginButtonLabel(),
                      isLoading: controller.isLoginLoading.value,
                    ),
            )),
        20.verticalSpace,
        // Row(
        //   children: [
        //     Flexible(
        //         child: SecondaryButtonWidget(
        //             margin: EdgeInsets.only(left: 25, right: 10), onPressed: () {}, child: Brand(Brands.google, size: 24.w))),
        //     Flexible(
        //         child: SecondaryButtonWidget(
        //             margin: EdgeInsets.only(left: 10, right: 25), onPressed: () {}, child: Icon(Bootstrap.phone, size: 24.w))),
        //   ],
        // ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            spacing: 10.h,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Powered by ",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Image.asset(
                    "assets/images/common/axpert_03.png",
                    width: 25,
                  ),
                  Text(
                    " Axpert",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  FutureBuilder(
                      future: LogService.getVersion(),
                      builder: (context, snapShot) {
                        var value = '';

                        if (snapShot.hasData) {
                          value = snapShot.data.toString();
                        }

                        return Text(
                          value,
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color:
                                AppColors.primarySubTitleTextColorBlueGreyLight,
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  _getLoginButtonLabel() {
    if (controller.authType.value == AuthType.passwordOnly) return "Login";
    if (controller.authType.value == AuthType.both) return "Get OTP";
    return "Login";
  }
}
