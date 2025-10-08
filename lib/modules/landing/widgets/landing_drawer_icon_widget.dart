import 'package:axpert_space/modules/landing/controllers/landing_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingDrawerIconWidget extends GetView<LandingController> {
  const LandingDrawerIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: controller.landingDrawerController.toggleDrawer,
        child: ValueListenableBuilder(
          valueListenable: controller.landingDrawerController,
          builder: (_, value, __) => Icon(
            // CupertinoIcons.sidebar_left,
            value.visible
                ? CupertinoIcons.clear_circled
                : CupertinoIcons.text_justifyleft,
            // size: 30,
          ),
        ));
  }
}
