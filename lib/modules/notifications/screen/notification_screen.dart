import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/empty_widget.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
import 'package:axpert_space/modules/notifications/service/notification_service.dart';
import 'package:axpert_space/modules/notifications/widgets/notification_types_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/notification_setion_block.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notifications"),
        actions: [
          TextButton(
            onPressed: controller.showClearAllDlg,
            child: Text(
              "clear all",
              style: AppStyles.appBarTitleTextStyle.copyWith(
                  color: AppColors.primaryActionColorDarkBlue, fontSize: 12.sp),
            ),
          ),
          10.horizontalSpace,
        ],
      ),
      body: Obx(() {
        var groups = controller.groupedNotifications;
        var isListEmpty = controller.filteredNotifications.isEmpty;
        return Column(
          children: [
            Obx(
              () => Visibility(
                  visible: controller.isNotificationScreenLoading.value,
                  child: RainbowLoadingWidget()),
            ),
            20.verticalSpace,
            NotificationTypesWidget(),
            // Text(AppNotificationsService.fcmId.toString()),
            Expanded(
                child: isListEmpty
                    ? _notificationEmptyWidget()
                    : _notificationListWidget(groups)),
          ],
        );
      }),
    );
  }

  Widget _notificationListWidget(
      RxMap<String, List<FirebaseMessageModel>> groups) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      children: [
        if (groups["Today"]!.isNotEmpty)
          NotificationSetionBlock("Today", groups["Today"]!),
        if (groups["Yesterday"]!.isNotEmpty)
          NotificationSetionBlock("Yesterday", groups["Yesterday"]!),
        if (groups["Last 7 Days"]!.isNotEmpty)
          NotificationSetionBlock("Last 7 Days", groups["Last 7 Days"]!),
        if (groups["Older"]!.isNotEmpty)
          NotificationSetionBlock("Older", groups["Older"]!),
      ],
    );
  }

  Widget _notificationEmptyWidget() {
    var style = GoogleFonts.poppins(
      color: AppColors.primaryTitleTextColorBlueGrey,
      fontWeight: FontWeight.w500,
    );

    var type = controller.selectedNotificationTYpe.value;
    var isAll = (type == "All");

    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/common/no-data.png",
          width: 1.sw / 2,
        ),
        20.verticalSpace,
        isAll
            ? Text("Looks empty here… check back later.", style: style)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Nothing under ", style: style),
                  Icon(
                    controller.notificationTypeIcons[type],
                    size: 16.sp,
                    color: AppColors.getColorByNotificationType(type),
                  ),
                  Text(" $type",
                      style: style.copyWith(
                        color: AppColors.getColorByNotificationType(type),
                        fontWeight: FontWeight.w600,
                      )),
                  Text(" category yet.", style: style),
                ],
              )
      ],
    ));
  }
}
