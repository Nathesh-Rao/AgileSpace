import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/landing/controllers/landing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarWidget extends GetView<LandingController> {
  const BottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.currentBottomBarIndex.value,
        onTap: controller.setBottomBarIndex,
        elevation: 10,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        enableFeedback: false,
        useLegacyColorScheme: false,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: _bottomBarIcon(controller.dashboardIcon, 0), label: ''),
          BottomNavigationBarItem(icon: _bottomBarIcon(controller.payAttendanceIcon, 1), label: ''),
          BottomNavigationBarItem(icon: _bottomBarIcon(controller.calendarIcon, 2), label: ''),
          BottomNavigationBarItem(icon: _bottomBarIcon(controller.settingsIcon, 3), label: ''),
        ],
      ),
    );
  }

  Widget _bottomBarIcon(String icon, int index) {
    return SizedBox(
      width: 60.w,
      height: 60.w,
      child:
          Image.asset(icon, color: index == controller.currentBottomBarIndex.value ? AppColors.primaryActionIconColorBlue : null),
    );
  }
}
