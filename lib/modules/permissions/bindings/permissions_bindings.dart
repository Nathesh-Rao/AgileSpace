import 'package:get/get.dart';
import 'package:axpert_space/modules/permissions/controllers/permissions_controller.dart';

class PermissionsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionsController>(() => PermissionsController());
  }
}
