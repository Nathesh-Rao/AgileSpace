import 'package:axpert_space/common/widgets/chip_card_widget.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationTypesWidget extends GetView<NotificationController> {
  const NotificationTypesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      // color: Colors.amber,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 20.w, right: 30.w),
        // shrinkWrap: true,
        itemCount: controller.notificationTypeIcons.keys.length,
        scrollDirection: Axis.horizontal,

        itemBuilder: (context, index) =>
            _typeWidget(controller.notificationTypeIcons.keys.toList()[index]),
        separatorBuilder: (context, index) => 10.horizontalSpace,
      ),
    );
  }

  _typeWidget(String type) {
    return Obx(
      () {
        var isSelected = type.toLowerCase() ==
            controller.selectedNotificationTYpe.value.toLowerCase();
        return GestureDetector(
          onTap: () {
            controller.selectedNotificationTYpe.value = type;
          },
          child: Chip(
            avatar: Icon(
              controller.notificationTypeIcons[type],
              color: isSelected ? Colors.white : AppColors.text1,
            ),
            backgroundColor: isSelected ? AppColors.baseBlue : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
                side: isSelected
                    ? BorderSide(color: AppColors.baseBlue)
                    : BorderSide.none),
            label: Text(type),
            labelStyle: AppStyles.actionButtonStyle.copyWith(
              color: isSelected ? Colors.white : AppColors.text1,
            ),
          ),
        );
      },
    );
  }
}
