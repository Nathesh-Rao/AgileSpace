import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationIconWidget extends GetView<NotificationController> {
  const NotificationIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Badge(
          isLabelVisible: controller.showBadge.value,
          label: Text(controller.badgeCount.value.toString()),
          child: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.notification);
              },
              child: Icon(CupertinoIcons.bell_fill))),
    );
  }
}
