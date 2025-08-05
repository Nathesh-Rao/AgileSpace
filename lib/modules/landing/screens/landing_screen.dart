import 'package:axpert_space/modules/landing/landing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/widgets.dart';

class LandingScreen extends GetView<LandingController> {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: 4,
          controller: controller.landingPageViewController,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return controller.landingPageTabs[index];
          }),
      bottomNavigationBar: BottomBarWidget(),
    );
  }
}
