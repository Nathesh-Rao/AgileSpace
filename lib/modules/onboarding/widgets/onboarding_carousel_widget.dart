import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingCarouselWidget extends GetView<OnBoardingController> {
  const OnboardingCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var imageList = [
      controller.onBoardingOneImage,
      controller.onBoardingTwoImage,
      controller.onBoardingThreeImage,
    ];

    return SizedBox(
      height: 375.h,
      child: PageView.builder(
        itemCount: 3,
        controller: controller.pageViewControllerImage,
        onPageChanged: controller.onBoardingCarouselCallBack,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(10.w),
            child: Image.asset(
              imageList[index],
            ),
          );
        },
      ),
    );
  }
}
