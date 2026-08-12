import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveListProgressWidget extends GetView<ActiveListController> {
  const ActiveListProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isListLoading.value,
        child: SizedBox(
          height: 1,
          child: LinearProgressIndicator(
            color: AppColors.drawerPrimaryColorViolet,
          ),
        ),
      ),
    );
  }
}
