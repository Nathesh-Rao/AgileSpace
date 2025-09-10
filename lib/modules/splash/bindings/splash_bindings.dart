import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/utils/internet_connections/internet_connectivity.dart';
import 'package:get/get.dart';
import 'package:axpert_space/modules/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.put<GlobalVariableController>(GlobalVariableController(),
        permanent: true);
    Get.put<InternetConnectivity>(InternetConnectivity(), permanent: true);
  }
}
