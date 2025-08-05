import 'package:get/get.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/routes/app_routes.dart';

class SplashController extends GetxController {
  var splashLogo = 'assets/images/common/app_logo.png';
  var splashToWelcomeHeroTag = HeroTags.splashToWelcomeHeroTag;

  @override
  void onReady() {
    _getInitialData();
    super.onReady();
  }

  _getInitialData() async {
    await Future.delayed(Duration(seconds: 3));
    _startNavigation();
  }

  _startNavigation() {
    Get.toNamed(AppRoutes.welcome);
  }
}
