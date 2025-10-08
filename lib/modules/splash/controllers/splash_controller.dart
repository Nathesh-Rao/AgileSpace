import 'package:get/get.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/core.dart';

class SplashController extends GetxController {
  var splashLogo = 'assets/images/common/axpert_space.png';
  var splashToWelcomeHeroTag = HeroTags.splashToWelcomeHeroTag;
  AppStorage appStorage = AppStorage();

  GlobalVariableController globalVariableController = Get.find();

  @override
  void onReady() {
    _getInitialData();
    super.onReady();
  }

  _getInitialData() async {
    globalVariableController.WEB_URL.value = Const.BASE_WEB_URL;

    globalVariableController.ARM_URL.value = Const.CONST_ARM_URL;

    globalVariableController.PROJECT_NAME.value = Const.CONST_PROJECTNAME;

//
//
//
    if (appStorage.retrieveValue(AppStorage.ARM_URL) == null) {
      appStorage.storeValue(
          AppStorage.ARM_URL, globalVariableController.ARM_URL.value);
      appStorage.storeValue(
          AppStorage.PROJECT_URL, globalVariableController.WEB_URL.value);
      appStorage.storeValue(
          AppStorage.PROJECT_NAME, globalVariableController.PROJECT_NAME.value);
    }

    await Future.delayed(Duration(seconds: 3));
    await _startNavigation();
  }

  _startNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    var isFirstTime = prefs.getBool(AppStorage.IS_FIRST_TIME) ?? true;
    // AppSnackBar.showSuccess("isFirstTime", isFirstTime.toString());
    if (isFirstTime) {
      Get.toNamed(AppRoutes.welcome);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
