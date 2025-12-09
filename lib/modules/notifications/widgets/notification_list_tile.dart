import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../model/firebase_message_model.dart';

class NotificationTile extends GetView<NotificationController> {
  final FirebaseMessageModel msg;

  const NotificationTile(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   isThreeLine: true,
    //   title: Text(
    //     msg.title,
    //     style: AppStyles.leaveActivityMainStyle.copyWith(fontSize: 14.sp),
    //   ),
    //   subtitle: Text(
    //     msg.body,
    //     style: AppStyles.searchFieldTextStyle
    //         .copyWith(fontSize: 12.sp, color: AppColors.text1),
    //   ),
    //   leading: CircleAvatar(
    //     backgroundColor:
    //         AppColors.getColorByNotificationType(msg.type.toLowerCase()),
    //   ),
    //   trailing: _getTrailingByType(msg.type),
    // );

    return Slidable(
      key: ValueKey(msg.timestamp.toIso8601String()),
      // endActionPane: ActionPane(
      //   extentRatio: 0.3,
      //   motion: const ScrollMotion(),
      //   children: [
      // SlidableAction(
      //   autoClose: true,
      //   onPressed: (_) {
      //     controller.deleteNotification(msg);
      //   },
      //   backgroundColor: AppColors.baseRed,
      //   foregroundColor: Colors.white,
      //   // icon: Icons.delete,
      //   // label: 'Delete',

      // ),

      // ],
      // ),

      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const StretchMotion(),
        children: [
          CustomSlidableAction(
            padding: EdgeInsets.all(10.h),
            autoClose: true,
            // backgroundColor: AppColors.baseRed.withAlpha(10),
            foregroundColor: AppColors.baseRed,
            onPressed: (_) => controller.showDeleteSingleDlg(msg),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.baseRed.withAlpha(55),
              ),
              child: Center(
                child: Icon(
                  Icons.delete,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ],
      ),

      child: ListTile(
        isThreeLine: true,
        title: Text(
          msg.title,
          style: AppStyles.leaveActivityMainStyle.copyWith(fontSize: 14.sp),
        ),
        subtitle: _getSubtitleByType(msg.type),
        leading: CircleAvatar(
          backgroundColor: AppColors.getColorByNotificationType(
            msg.type.toLowerCase(),
          ),
          child: Icon(
            // Icons.abc,
            controller.notificationTypeIcons[msg.type.capitalize] ??
                Icons.notifications_active,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
        trailing: _getTrailingByType(msg.type),
      ),
    );
  }

  Widget _getSubtitleByType(String type) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          msg.body,
          style: AppStyles.searchFieldTextStyle
              .copyWith(fontSize: 12.sp, color: AppColors.text1),
        )
      ],
    );
  }

  Widget? _getTrailingByType(String type) {
    if (type.toLowerCase() == "promotion") {
      var imageLink = msg.raw["promotion_image"] ?? "";

      return Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            image: DecorationImage(
                image: NetworkImage(imageLink), fit: BoxFit.cover)),
      );
    }

    return null;
  }
}
