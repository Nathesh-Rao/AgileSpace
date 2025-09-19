import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/landing/controllers/landing_controller.dart';
import 'package:axpert_space/modules/modules.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';

class LandingDrawerWidget extends GetView<LandingController> {
  const LandingDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalVariableController globalVariableController = Get.find();
    TaskController taskController = Get.find();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            20.verticalSpace,
            Container(
              decoration: BoxDecoration(
                  // color: Colors.grey.shade400,
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/common/axpert_space.png',
                    width: 60.w,
                  ),
                  10.verticalSpace,
                  Text(
                    "AxpertSpace",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              spacing: 10.w,
              children: [
                Obx(
                  () => CircleAvatar(
                    backgroundImage: AssetImage(
                        globalVariableController.PROFILE_PICTURE.value),
                  ),
                ),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        globalVariableController.NICK_NAME.value,
                        style: AppStyles.appBarTitleTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryActionColorDarkBlue,
                        ),
                      ),
                      Text(
                        globalVariableController.USER_EMAIL.value,
                        style: AppStyles.appBarTitleTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryActionColorDarkBlue,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Obx(() => Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: controller.drawerScrollProgress.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.drawerPrimaryColorViolet,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                )),
            Expanded(
              child: Obx(
                () => controller.menuFinalList.isNotEmpty
                    ? ListView(
                        controller: controller.drawerScrollController,
                        children: [
                          // AnimatedContainer(
                          //   height: controller.drawerHeadExpandSwitch.value
                          //       ? double.infinity
                          //       : 20,
                          //   color: Colors.amber,
                          //   constraints: BoxConstraints(
                          //     maxHeight: 280,
                          //   ),
                          //   duration: Duration(milliseconds: 300),
                          //   child: controller.drawerHeadExpandSwitch.value
                          //       ? drawerHeadSectionListWidget(taskController)
                          //       : SizedBox.shrink(),
                          // ),

                          Theme(
                            data: ThemeData(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              collapsedBackgroundColor: Colors.white,
                              collapsedIconColor:
                                  AppColors.drawerPrimaryColorViolet,
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    spacing: 20.w,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Bootstrap.stack,
                                            size: 12.w,
                                            color: AppColors
                                                .drawerPrimaryColorViolet,
                                          ),
                                          5.horizontalSpace,
                                          Text(
                                            "${taskController.taskList.length.toString()} Tasks",
                                            style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors
                                                    .primarySubTitleTextColorBlueGreyLight),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Bootstrap.bell_fill,
                                            size: 12.w,
                                            color: AppColors
                                                .chipCardWidgetColorRed,
                                          ),
                                          5.horizontalSpace,
                                          Text(
                                            "${5} Notifications",
                                            style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors
                                                    .primarySubTitleTextColorBlueGreyLight),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              showTrailingIcon: true,
                              children:
                                  drawerHeadSectionListWidget(taskController),
                            ),
                          ),

                          Row(
                            children: [
                              Expanded(child: Divider()),
                              Icon(
                                CupertinoIcons.circle_fill,
                                size: 10,
                                color: AppColors.primaryTitleTextColorBlueGrey,
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          ...controller.getDrawerTileList()
                        ],
                      )
                    : SizedBox.shrink(),
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              child: Container(
                color: Colors.white,
                height: 70,
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      'App Version: ${Const.APP_VERSION}',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/common/axpert.png',
                          height: Get.height * 0.03,
                          // width: MediaQuery.of(context).size.width * 0.075,
                          fit: BoxFit.fill,
                        ),
                        Text(" © ${DateTime.now().year} Powered by Axpert"),
                      ],
                    )
                  ],
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> drawerHeadSectionListWidget(TaskController taskController) {
    return [
      _bottomBarListTile1(
        defaultIndex: 0,
        currentIndex: controller.currentBottomBarIndex.value,
        label: "All Tasks",
        leadingIcon: "assets/icons/bottom_nav/dashboard_icon.png",
        trailing: taskController.taskList.length.toString(),
      ),
      _bottomBarListTile1(
        defaultIndex: 1,
        currentIndex: controller.currentBottomBarIndex.value,
        label: "Pay and Attendance",
        leadingIcon: "assets/icons/bottom_nav/pay_attendance_icon.png",
      ),
      _bottomBarListTile1(
        defaultIndex: 2,
        currentIndex: controller.currentBottomBarIndex.value,
        label: "Calendar",
        leadingIcon: "assets/icons/bottom_nav/calendar_icon.png",
      ),
      _bottomBarListTile1(
        defaultIndex: 3,
        currentIndex: controller.currentBottomBarIndex.value,
        label: "Settings",
        leadingIcon: "assets/icons/bottom_nav/settings_icon.png",
      ),
      _bottomBarListTile1(
          defaultIndex: 4,
          currentIndex: controller.currentBottomBarIndex.value,
          label: "Notification",
          leadingIcon: "assets/icons/bottom_nav/notification_bell_icon.png",
          trailing: "3",
          trailingBgColor: AppColors.chipCardWidgetColorRed,
          trailingColor: Colors.white,
          onTap: () {
            Get.toNamed(AppRoutes.notification);
          }),
    ];
  }

  _bottomBarListTile1({
    required String label,
    required String leadingIcon,
    String? trailing,
    Color? trailingBgColor,
    Color? trailingColor,
    required currentIndex,
    required defaultIndex,
    double? iconWidth,
    void Function()? onTap,
  }) {
    var isSelected = currentIndex == defaultIndex;

    return InkWell(
      onTap: onTap ??
          () {
            controller.setBottomBarIndex(defaultIndex);
            controller.landingDrawerController.toggleDrawer();
          },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.drawerPrimaryColorViolet : Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          children: [
            Image.asset(
              leadingIcon,
              width: iconWidth ?? 40.w,
              color: isSelected
                  ? Colors.white
                  : AppColors.primaryTitleTextColorBlueGrey,
            ),
            5.horizontalSpace,
            Text(
              label,
              style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : AppColors.primaryTitleTextColorBlueGrey),
            ),
            Spacer(),
            trailing != null
                ? Container(
                    height: 20.h,
                    width: 20.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.r),
                      color: trailingBgColor ?? Color(0xffB5EBCD),
                    ),
                    child: Center(
                      child: Text(
                        trailing,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: trailingColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                : SizedBox.shrink(),
            10.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
