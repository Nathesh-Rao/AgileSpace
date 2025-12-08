import 'package:get/get.dart';

import '../../common/common.dart';
import '../../modules/notifications/controller/notification_controller.dart';
import '../utils/internet_connections/internet_connectivity.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Get.put<GlobalVariableController>(GlobalVariableController(),
    //     permanent: true);

        Get.put<GlobalVariableController>(GlobalVariableController(),
        permanent: true);
    Get.put<InternetConnectivity>(InternetConnectivity(), permanent: true);
    Get.put<NotificationController>(NotificationController(), permanent: true);
  }

  // static initMainControllers() {

  // }
}
