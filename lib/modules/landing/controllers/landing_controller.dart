import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/tabs/tabs.dart';

class LandingController extends GetxController {
  var dashboardIcon = "assets/icons/bottom_nav/dashboard_icon.png";
  var payAttendanceIcon = "assets/icons/bottom_nav/pay_attendance_icon.png";
  var calendarIcon = "assets/icons/bottom_nav/calendar_icon.png";
  var settingsIcon = "assets/icons/bottom_nav/settings_icon.png";

  PageController landingPageViewController = PageController();

  var landingPageTabs = [LandingTaskTab(), LandingPayAndAttendanceTab(), LandingCalendarTab(), LandingSettingsTab()];

  onPageViewChange(int newIndex) {
    currentBottomBarIndex.value = newIndex;
  }

  var currentBottomBarIndex = 0.obs;

  setBottomBarIndex(int newIndex) {
    if (currentBottomBarIndex.value == newIndex) return;

    if ((currentBottomBarIndex.value - newIndex).abs() == 1) {
      landingPageViewController.animateToPage(newIndex, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      landingPageViewController.jumpToPage(newIndex);
    }
    currentBottomBarIndex.value = newIndex;
  }

  @override
  void dispose() {
    landingPageViewController.dispose();
    super.dispose();
  }
}
