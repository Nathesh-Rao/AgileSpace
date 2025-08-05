import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import '../controllers/onboarding_controller.dart';

class WelcomeScreen extends GetView<OnBoardingController> {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("WELCOME"),
      ),
      body: Column(
        children: [
          Spacer(),
          Hero(
              tag: HeroTags.splashToWelcomeHeroTag,
              child: ZoomIn(
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(controller.welcomeScreenImage),
                ),
              )),
          Expanded(
              flex: 3,
              child: SlideInUp(
                from: 50.h,
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      "Get Started Now",
                      style: AppStyles.onboardingTitleTextStyle,
                    ),
                    Text(
                      "Create an account or Login to  Explore\nabout our app",
                      textAlign: TextAlign.center,
                      style: AppStyles.onboardingSubTitleTextStyle,
                    ),
                    Spacer(),
                    PrimaryButtonWidget(onPressed: controller.onWelcomeNextButtonClick, label: "Next"),
                    40.verticalSpace,
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
