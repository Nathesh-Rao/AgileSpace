import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/landing/controllers/landing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';
import '../models/landing_menu_item_model.dart';

class LandingDrawerMenuWidget extends GetView<LandingController> {
  const LandingDrawerMenuWidget(
      {super.key, required this.tile, required this.leftPadding});
  final MenuItemModel tile;
  final double leftPadding;
  @override
  Widget build(BuildContext context) {
    if (tile.childList.isEmpty) {
      return Visibility(
        visible: tile.visible.toUpperCase() == "T",
        child: InkWell(
          onTap: () {
            controller.openItemClick(tile);
          },
          child: ListTile(
            tileColor: Colors.white,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.generateIcon(tile, 1),
                  color: AppColors.primaryTitleTextColorBlueGrey,
                ),
              ],
            ),
            contentPadding: EdgeInsets.only(left: leftPadding),
            title: Text(tile.caption,
                style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTitleTextColorBlueGrey)),
          ),
        ),
      );
    } else {
      return Visibility(
        visible: tile.visible.toUpperCase() == "T",
        child: Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white70,
            collapsedIconColor: AppColors.drawerPrimaryColorViolet,
            leading: Icon(controller.generateIcon(tile, 1),
                color: AppColors.primaryTitleTextColorBlueGrey),
            tilePadding: EdgeInsets.only(left: leftPadding, right: 10),
            title: Text(tile.caption,
                style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTitleTextColorBlueGrey)),
            children: tile.childList
                .map((tile) => controller.buildInnerListTile(tile,
                    leftPadding: leftPadding + 15))
                .toList(),
          ),
        ),
      );
    }
  }
}
