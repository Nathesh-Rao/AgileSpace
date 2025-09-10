import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:axpert_space/modules/splash/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Pulse(
          from: 0.8,
          to: 1,
          infinite: true,
          duration: const Duration(seconds: 3),
          child: Hero(
            tag: controller.splashToWelcomeHeroTag,
            child: Image.asset(
              controller.splashLogo,
              width: 180,
              height: 180,
            ),
          ),
        ),
      ),
    );
  }
}
