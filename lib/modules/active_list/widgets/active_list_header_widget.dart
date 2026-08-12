import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:axpert_space/modules/active_list/widgets/active_list_filter_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';

class ActiveListHeaderWidget extends GetView<ActiveListController> {
  const ActiveListHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimarySearchFieldWidget(
            controller: controller.searchTextController,
            onChanged: controller.searchTask,
            onSuffixTap: controller.clearSearch,
          ),
          5.horizontalSpace,
          Obx(
            () => IconButton(
              style: IconButton.styleFrom(
                  backgroundColor: controller.isFilterOn.value
                      ? AppColors.chipCardWidgetColorBlue
                      : AppColors.chipCardWidgetColorBlue.withAlpha(20),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppColors.chipCardWidgetColorBlue,
                      ),
                      borderRadius: BorderRadius.circular(5.r))),
              onPressed: () {
                Get.dialog(
                    useSafeArea: false,
                    barrierDismissible: false,
                    ActiveListFilterWidget());
              },
              icon: controller.isFilterOn.value
                  ? Icon(
                      Icons.filter_alt,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.filter_alt_off,
                      color: AppColors.chipCardWidgetColorBlue,
                    ),
            ),
          ),
          Obx(
            () => IconButton(
              style: IconButton.styleFrom(
                  backgroundColor:
                      AppColors.chipCardWidgetColorViolet.withAlpha(20),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppColors.chipCardWidgetColorViolet,
                      ),
                      borderRadius: BorderRadius.circular(5.r))),
              onPressed: () {
                controller.showBulkApprovalDlg();
              },
              icon: !controller.isBulkApprovalLoading.value
                  ? Icon(
                      Icons.done_all,
                      color: AppColors.chipCardWidgetColorViolet,
                    )
                  : CupertinoActivityIndicator(
                      radius: 9.w,
                      color: AppColors.chipCardWidgetColorViolet,
                    ),
            ),
          ),
          5.horizontalSpace,
        ],
      ),
    );
  }
}
