import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';

class TaskOverviewCountWidget extends GetView<TaskController> {
  const TaskOverviewCountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AutoSizeText(
          "There are ${controller.pendingTaskCount.value} Tasks to complete today ",
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
        ).skeletonLoading(controller.isTaskOverviewLoading.value));
  }
}
