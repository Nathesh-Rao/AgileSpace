import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import 'active_list_details_history_widget.dart';

class ActiveListDetailsHeaderWidget
    extends GetView<ActiveListDetailsController> {
  const ActiveListDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchActiveListDetails();
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => AnimatedSwitcherPlus.wipeX(
            duration: Duration(milliseconds: 500),
            child: controller.isActiveListDetailsLoading.value
                ? RainbowLoadingWidget(
                    key: ValueKey("Rainbow"),
                  )
                : SizedBox.shrink(
                    key: ValueKey("notARainbow"),
                  ),
          ),
        ),
        ActiveListDetailsHistoryWidget()
      ],
    );
  }
}
