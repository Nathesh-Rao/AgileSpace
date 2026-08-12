import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/onboarding/controllers/onboarding_controller.dart';

class OnboardingPageIndicatorWidget extends GetView<OnBoardingController> {
  const OnboardingPageIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) => _circleIndicatorWidget(index == controller.currentPageIndex.value)),
      ),
    );
  }

  Widget _circleIndicatorWidget(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: isActive ? 5 : 2),
      width: isActive ? 30.w : 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(50.r),
        color: isActive ? AppColors.primaryButtonBGColorViolet : AppColors.primarySubTitleTextColorBlueGreyLight,
      ),
    );
  }
}
