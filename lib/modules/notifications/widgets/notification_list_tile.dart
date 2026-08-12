import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../model/firebase_message_model.dart';

class NotificationTile extends GetView<NotificationController> {
  final FirebaseMessageModel msg;

  const NotificationTile(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slidable(
          key: ValueKey(msg.timestamp.toIso8601String()),
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
          child: StatefulBuilder(builder: (context, setstate) {
            return Container(
              decoration: BoxDecoration(
                color: msg.isOpened
                    ? null
                    : AppColors.getColorByNotificationType(msg.type)
                        .withAlpha(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5.h,
                  horizontal: 30.w,
                ),
                selected: !msg.isOpened,
                selectedColor: AppColors.getColorByNotificationType(msg.type),
                titleTextStyle: AppStyles.leaveActivityMainStyle.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.primaryTitleTextColorBlueGrey,
                ),
                onTap: () {
                  setstate(() {
                    controller.onNotificationTileClick(msg);
                  });
                },
                isThreeLine: true,
                title: Text(
                  msg.title,
                ),
                subtitle: _getSubtitleByType(msg.type),
                leading: _leadingWidget(msg),
                trailing: _getTrailingByType(msg.type),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _leadingWidget(FirebaseMessageModel msg) {
    if (!msg.isOpened) {
      return Badge(
        alignment: Alignment.topRight,
        offset: const Offset(5, 0),
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero, // important
        label: Container(
          width: 12.w,
          height: 12.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.circle,
              size: 6.sp,
              color: AppColors.getColorByNotificationType(
                msg.type.toLowerCase(),
              ),
            ),
          ),
        ),
        child: CircleAvatar(
          backgroundColor: AppColors.getColorByNotificationType(
            msg.type.toLowerCase(),
          ),
          child: Icon(
            controller.getNotificationIconByTypeAndAction(msg),
            color: Colors.white,
            size: 18.sp,
          ),
        ),
      );
    }

    return CircleAvatar(
      backgroundColor: AppColors.getColorByNotificationType(
        msg.type.toLowerCase(),
      ).withAlpha(50),
      child: Icon(
        // Icons.abc,
        controller.getNotificationIconByTypeAndAction(msg),
        color: AppColors.getColorByNotificationType(
          msg.type.toLowerCase(),
        ),
        size: 18.sp,
      ),
    );
  }

  Widget _getSubtitleByType(String type) {
    var showActions = false;

    List<Widget> addWidgets = [];
    if (type.toLowerCase() == "task") {
      addWidgets.add(
        StatefulBuilder(builder: (context, setValue) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setValue(() {
                        showActions = !showActions;
                      });
                    },
                    child: Icon(
                      showActions
                          ? Iconsax.close_circle_bold
                          : Iconsax.more_circle_bold,
                    ),
                  ),
                ],
              ),
              showActions
                  ? Container(
                      height: 55.h,
                      margin: EdgeInsets.only(top: 10.h),
                      // width: 1.sw / 2,
                      color: Colors.amber,
                    )
                  : SizedBox.shrink()
            ],
          );
        }),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                msg.body,
                style: AppStyles.searchFieldTextStyle
                    .copyWith(fontSize: 12.sp, color: AppColors.text1),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
            children: [
              Text(
                controller.getDateForNotification(msg),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primarySubTitleTextColorBlueGreyLight,
                  fontSize: 12.sp,
                ),
              ),
              50.horizontalSpace,
            ],
          ),
        ),
        // ...addWidgets,
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
