// ignore_for_file: non_constant_identifier_names

import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/core/utils/extensions.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/flat_button_widget.dart';
import 'active_list_bulk_approve_comment_widget.dart';

class ActiveListBulkApproveWidget extends GetView<ActiveListController> {
  const ActiveListBulkApproveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Bulk Approve",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.chipCardWidgetColorViolet,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                "View the tasks you can approve in bulk",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              Obx(
                () => ListView(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  shrinkWrap: true,
                  children: controller.bulkApprovalCount_list
                      .map(
                        (bt) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: ListTile(
                            tileColor: AppColors.chipCardWidgetColorViolet
                                .withAlpha(25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              // side: BorderSide(
                              //   color: AppColors.baseBlue.withAlpha(50),
                              // ),
                            ),
                            onTap: () {
                              Get.back();
                              controller.getBulkActiveTasks(
                                  bt.processname.toString());
                              Get.dialog(showBulkApproval_DetailDialog(
                                context,
                                bt.processname.toString(),
                              ));
                            },
                            leading: Icon(
                              CupertinoIcons.collections,
                              size: 18.sp,
                              color: AppColors.chipCardWidgetColorViolet,
                            ),
                            title: Text(bt.processname.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.chipCardWidgetColorViolet,
                                )),
                            trailing: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.chipCardWidgetColorViolet
                                    .withAlpha(30),
                              ),
                              padding: EdgeInsets.all(8.w),
                              child: Text(
                                bt.pendingapprovals.toString(),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    color: AppColors.chipCardWidgetColorViolet),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              10.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: FlatButtonWidget(
                      width: 100.w,
                      label: "Cancel",
                      color: AppColors.grey6,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  // Spacer(),
                ],
              )
            ],
          ),
        ));
  }

  Widget showBulkApproval_DetailDialog(
    BuildContext context,
    String pName,
  ) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        pName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.chipCardWidgetColorViolet,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      Checkbox(
                          side: BorderSide(
                            color: AppColors.drawerPrimaryColorViolet,
                          ),
                          checkColor: Colors.white,
                          activeColor: AppColors.chipCardWidgetColorViolet,
                          value: controller.isBulkAppr_SelectAll.value,
                          onChanged: (v) {
                            controller.selectAll_BulkApproveList_item(v);
                          }),
                      10.horizontalSpace,
                    ],
                  ),
                  8.verticalSpace,
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 300.h,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: controller.bulkApproval_activeList
                          .map((t) => _approveListTile(t))
                          .toList(),
                    ),
                  ),
                  10.verticalSpace,
                  // Obx(
                  //   ()=> Spin(
                  //       infinite: true,
                  //       animate: controller.isBulkApprovelSubmitLoading.value,
                  //       child: Icon(Icons.more_horiz)),
                  // ),
                  Icon(Icons.more_horiz),
                  ActiveListBulkApproveCommentWidget(),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: FlatButtonWidget(
                          width: 100.w,
                          label: "Cancel",
                          color: AppColors.grey4,
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                      // Spacer(),
                      20.horizontalSpace,
                      Expanded(
                        child: FlatButtonWidget(
                          width: 100.w,
                          label: "Bulk Approve",
                          color: AppColors.flatButtonColorPurple,
                          onTap: () {
                            controller.doBulkApprove().then((_) {
                              controller.refreshList();
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget widgetBulkApproval_ListItem(itemModel) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  itemModel.displaytitle.toString(),
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff495057))),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  // selectable: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(itemModel.displaycontent.toString(),
              maxLines: 1,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 11,
                  color: Color(0xff495057),
                ),
              )),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.person,
              ),
              SizedBox(
                width: 5,
              ),
              Text(itemModel.fromuser.toString().capitalize!,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff495057),
                    ),
                  ))
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16),
              SizedBox(width: 10),
              Text(controller.getDateValue(itemModel.eventdatetime),
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff495057),
                    ),
                  )),
              Expanded(child: Text("")),
              Icon(Icons.access_time, size: 16),
              SizedBox(width: 5),
              Text(controller.getDateValue(itemModel.eventdatetime),
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff495057),
                    ),
                  )),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _approveListTile(t) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: t.bulkApprove_isSelected.value
              ? AppColors.grey.withAlpha(20)
              : AppColors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(7.r),
          border: t.bulkApprove_isSelected.value
              ? Border.all(
                  color: AppColors.grey,
                )
              : null,
        ),
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.only(bottom: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    t.displaytitle.toString(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryActionColorDarkBlue,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                ),
                // Spacer(),
                Checkbox(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    side: BorderSide(
                      color: AppColors.drawerPrimaryColorViolet,
                    ),
                    checkColor: Colors.white,
                    activeColor: AppColors.chipCardWidgetColorViolet,
                    value: t.bulkApprove_isSelected.value,
                    onChanged: (v) {
                      controller.onChange_BulkApproveItem(t, v);
                    })
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    t.displaycontent.toString(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTitleTextColorBlueGrey,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 3.w,
                    children: [
                      Icon(
                        CupertinoIcons.person_fill,
                        size: 9.sp,
                        color: AppColors.primaryActionColorDarkBlue,
                      ),
                      Text(
                        t.fromuser.toString().capitalize ?? "",
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryActionColorDarkBlue,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                10.horizontalSpace,
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5.w,
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 9.sp,
                        color: AppColors.primaryActionColorDarkBlue,
                      ),
                      Text(
                        controller.getDateValue(t.eventdatetime),
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryActionColorDarkBlue,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            5.verticalSpace,
          ],
        ),
      ).skeletonLoading(controller.isBulkApprovelSubmitLoading.value),
    );
  }
}
