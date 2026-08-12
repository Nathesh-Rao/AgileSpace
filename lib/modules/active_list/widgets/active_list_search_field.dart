import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';

class WidgetActiveListSearchField extends GetView<ActiveListController> {
  const WidgetActiveListSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => TextField(
          controller: controller.searchTextController,
          onChanged: controller.searchTask,
          decoration: InputDecoration(
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: AppColors.floatButtonBaseColorBlueGray,
                size: 24,
              ),
              suffixIcon: controller.taskSearchText.value.isNotEmpty
                  ? InkWell(
                      onTap: controller.clearSearch,
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: AppColors.baseRed.withAlpha(150),
                        size: 24,
                      ),
                    )
                  : null,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: "Search...",
              hintStyle: GoogleFonts.poppins(
                color: AppColors.baseGray,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(width: 1, color: Color(0xffD0D0D0)))),
        ),
      ),
    );
  }
}
