import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/common/common.dart';
import '../../../core/core.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/widgets.dart';

class OnboardingScreen extends GetView<OnBoardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: controller.onSkipButtonClick,
              child: Text(
                "SKIP",
                style: AppStyles.textButtonStyle,
              ))
        ],
      ),
      body: Column(
        children: [
          Spacer(flex: 2),
          OnboardingCarouselWidget(),
          Spacer(flex: 2),
          OnboardingPageIndicatorWidget(),
          OnboardingTextWidget(),
          Obx(() => PrimaryButtonWidget(
              onPressed: controller.onOnBoardingNextButtonClick,
              label: controller.currentPageIndex.value != 2 ? "Next" : "Start")),
          40.verticalSpace,
        ],
      ),
    );
  }
}
