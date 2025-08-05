import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingTextWidget extends GetView<OnBoardingController> {
  const OnboardingTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: Center(
        child: PageView.builder(
          itemCount: 3,
          controller: controller.pageViewControllerText,
          onPageChanged: controller.onBoardingCarouselCallBack,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) => _textWidget(index),
        ),
      ),
    );
  }

  _textWidget(index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          controller.onBoardingTitleList[index],
          style: AppStyles.onboardingTitleTextStyle,
        ),
        Text(
          controller.onBoardingSubTitleList[index],
          textAlign: TextAlign.center,
          style: AppStyles.onboardingSubTitleTextStyle,
        ),
      ],
    );
  }
}
