import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:axpert_space/routes/app_routes.dart';

class OnBoardingController extends GetxController {
  //Welcome Screen ====>
  var welcomeScreenImage = "assets/images/onboarding/welcome_header.png";

  onWelcomeNextButtonClick() {
    Get.toNamed(
      AppRoutes.onBoarding,
    );
  }

  //onBoarding Screens ====>
  var onBoardingOneImage = "assets/images/onboarding/onboarding_1.png";
  var onBoardingTwoImage = "assets/images/onboarding/onboarding_2.png";
  var onBoardingThreeImage = "assets/images/onboarding/onboarding_3.png";

  var currentPageIndex = 0.obs;
  var pageViewControllerImage = PageController();
  var pageViewControllerText = PageController();
  @override
  void onReady() {
    pageViewControllerImage.addListener(() {
      if (pageViewControllerText.page != pageViewControllerImage.page) {
        pageViewControllerText.jumpTo(pageViewControllerImage.offset);
      }
    });

    super.onReady();
  }

  var onBoardingTitleList = [
    "Welcome to ESS",
    "Simplified Workflows",
    "Stay Informed Always",
  ];
  var onBoardingSubTitleList = [
    "Manage your work life—from attendance to salary—\nwithout the paperwork in One Place.",
    "Apply leaves, track attendance, and plan ahead—all\nwith just a few taps.",
    "Get real-time alerts about approvals, announcements,\nand documents.",
  ];

  onOnBoardingNextButtonClick() async {
    if (pageViewControllerImage.page == 2) {
      Get.toNamed(AppRoutes.permissionLocation);
    } else {
      await pageViewControllerImage.nextPage(duration: Duration(milliseconds: 400), curve: Curves.decelerate);
    }
  }

  onBoardingCarouselCallBack(int currentIndex) {
    currentPageIndex.value = currentIndex;
  }

  onSkipButtonClick() async {
    await pageViewControllerImage.animateToPage(2, duration: Duration(milliseconds: 600), curve: Curves.decelerate);
  }

  @override
  void dispose() {
    pageViewControllerImage.dispose();
    pageViewControllerText.dispose();
    super.dispose();
  }
}
