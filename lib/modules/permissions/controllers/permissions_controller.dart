import 'package:axpert_space/common/common.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:axpert_space/routes/app_routes.dart';

class PermissionsController extends GetxController {
  //Location Permission Screen

  var isPermissionLoading = false.obs;

  var permissionLocationImage = "assets/images/onboarding/location_header.png";
  onEnableLocationButtonClick() async {
    var permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Get.toNamed(AppRoutes.permissionNotification);
    } else {
      AppSnackBar.showError("Location permission denied",
          "Try to enable location from settings for better working of the app");
    }
  }

  onAnotherTimeLocationButtonClick() {
    Get.toNamed(AppRoutes.permissionNotification);
  }

  //Notification Permission Screen
  var permissionNotificationImage =
      "assets/images/onboarding/notification_header.png";
  onEnableNotificationButtonClick() {
    Get.toNamed(AppRoutes.login);
  }

  onAnotherTimeNotificationButtonClick() {
    Get.toNamed(AppRoutes.login);
  }
}
