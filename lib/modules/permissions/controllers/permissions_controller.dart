import 'package:get/get.dart';
import 'package:axpert_space/routes/app_routes.dart';

class PermissionsController extends GetxController {
  //Location Permission Screen
  var permissionLocationImage = "assets/images/onboarding/location_header.png";
  onEnableLocationButtonClick() {
    Get.toNamed(AppRoutes.permissionNotification);
  }

  onAnotherTimeLocationButtonClick() {
    Get.toNamed(AppRoutes.permissionNotification);
  }

  //Notification Permission Screen
  var permissionNotificationImage = "assets/images/onboarding/notification_header.png";
  onEnableNotificationButtonClick() {
    Get.toNamed(AppRoutes.login);
  }

  onAnotherTimeNotificationButtonClick() {
    Get.toNamed(AppRoutes.login);
  }
}
