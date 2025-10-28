import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../common/widgets/flat_button_widget.dart';
import '../../../task/widgets/widgets.dart';

class ActiveListDetailsDialogWidget
    extends GetView<ActiveListDetailsController> {
  const ActiveListDetailsDialogWidget(
      {super.key, required this.dlgType, required this.color});

  final String dlgType;
  final Color color;
  @override
  Widget build(BuildContext context) {
    String title = _getTitle(dlgType);
    String subTitle = _getSubTitle(dlgType);
    Widget bodyWidget = _getBodyWidget(dlgType);
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                subTitle,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              15.verticalSpace,
              bodyWidget
            ])));
  }

  String _getTitle(String dlgType) {
    if (dlgType.toLowerCase().contains("history")) {
      return dlgType;
    }

    return "$dlgType Task";
  }

  String _getSubTitle(String dlgType) {
    if (dlgType.toLowerCase().contains("history")) {
      return "View the task History";
    }
    return "$dlgType the task you selected";
  }

  Widget _getBodyWidget(String dlgType) {
    var txt = dlgType.toLowerCase();

    if (txt.contains("check")) {
      return _getCheckBody();
    } else if (txt.contains("reject")) {
      return _getRejectBody();
    } else if (txt.contains("return")) {
      return _getReturnBody();
    } else if (txt.contains("send")) {
      return _getSendBody();
    } else if (txt.contains("view")) {
      return _getViewBody();
    } else if (txt.contains("history")) {
      return _getHistoryBody();
    } else if (txt.contains("approve")) {
      return _getApproveBody();
    }

    return Container();
  }

  Widget _commentField(bool hasComments) {
    return TextField(
      controller: controller.comments,
      maxLines: null,
      // expands: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(5.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color),
          borderRadius: BorderRadius.circular(5.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color),
          borderRadius: BorderRadius.circular(5.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.baseRed),
          borderRadius: BorderRadius.circular(5.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.baseRed),
          borderRadius: BorderRadius.circular(5.r),
        ),

        // label: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       "Enter Comments",
        //       style: AppStyles.actionButtonStyle.copyWith(
        //         fontWeight: FontWeight.w400,
        //         color: AppColors.primarySubTitleTextColorBlueGreyLight,
        //       ),
        //     ),
        //     Text(
        //       hasComments ? "*" : "",
        //       style: AppStyles.actionButtonStyle.copyWith(
        //         fontWeight: FontWeight.w400,
        //         color: AppColors.baseRed,
        //       ),
        //     ),
        //   ],
        // ),
        labelText: "Enter Comments ${hasComments ? "*" : ""}",
        labelStyle: AppStyles.actionButtonStyle.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.primarySubTitleTextColorBlueGreyLight,
        ),
        floatingLabelStyle: AppStyles.actionButtonStyle.copyWith(
          fontWeight: FontWeight.w400,
          color: color,
        ),
        errorText:
            controller.errCom.value == '' ? null : controller.errCom.value,
        filled: true,
        fillColor: Color(0xffD9D9D9).withAlpha(100),
        // fillColor: color.withAlpha(10),
      ),
      style: GoogleFonts.poppins(
        color: Colors.black,
        fontSize: 12.sp,
      ),
    );
  }

  Widget _getCheckBody() {
    var hasComments = controller.pendingTaskModel?.approvalcomments
                .toString()
                .toLowerCase() ==
            't'
        ? true
        : false;
    return Column(
      children: [
        Visibility(
          visible: controller.pendingTaskModel!.cmsg_reject.toString() != ''
              ? true
              : false,
          child: Center(
              child: Text(
            controller.pendingTaskModel!.cmsg_appcheck.toString(),
            style: AppStyles.actionButtonStyle,
          )),
        ),
        // Row(
        //   children: [
        //     3.horizontalSpace,
        //     Text("Comments",
        //         style: AppStyles.onboardingSubTitleTextStyle.copyWith(
        //           fontWeight: FontWeight.w400,
        //           color: AppColors.primarySubTitleTextColorBlueGreyLight,
        //         )),
        //   ],
        // ),
        5.verticalSpace,
        Obx(() => _commentField(hasComments)),
        20.verticalSpace,
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
            10.horizontalSpace,
            Expanded(
              child: FlatButtonWidget(
                width: 100.w,
                label: "Check",
                color: color,
                onTap: () {
                  if (_checkComments(hasComments)) {
                    controller.actionApproveOrRejectOrCheck(
                        hasComments, "Check");
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getRejectBody() {
    var hasComments =
        controller.pendingTaskModel?.returncomments.toString().toLowerCase() ==
                't'
            ? true
            : false;

    return Column(
      children: [
        Visibility(
          visible: controller.pendingTaskModel!.cmsg_reject.toString() != ''
              ? true
              : false,
          child: Center(
              child: Text(
            controller.pendingTaskModel!.cmsg_appcheck.toString(),
            style: AppStyles.actionButtonStyle,
          )),
        ),
        // Row(
        //   children: [
        //     3.horizontalSpace,
        //     Text("Comments",
        //         style: AppStyles.onboardingSubTitleTextStyle.copyWith(
        //           fontWeight: FontWeight.w400,
        //           color: AppColors.primarySubTitleTextColorBlueGreyLight,
        //         )),
        //   ],
        // ),
        5.verticalSpace,
        Obx(() => _commentField(hasComments)),
        20.verticalSpace,
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
            10.horizontalSpace,
            Expanded(
              child: FlatButtonWidget(
                width: 100.w,
                label: "Reject",
                color: color,
                onTap: () {
                  if (_checkComments(hasComments)) {
                    controller.actionApproveOrRejectOrCheck(
                        hasComments, "Reject");
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getReturnBody() {
    var hasComments =
        controller.pendingTaskModel?.returncomments.toString().toLowerCase() ==
                't'
            ? true
            : false;
    return Column(
      children: [
        Visibility(
          visible: controller.pendingTaskModel!.cmsg_reject.toString() != ''
              ? true
              : false,
          child: Center(
              child: Text(
            controller.pendingTaskModel!.cmsg_appcheck.toString(),
            style: AppStyles.actionButtonStyle,
          )),
        ),
        Obx(
          () => PrimaryDropdownField(
            borderColor: color,
            value: controller.ddSelectedValue.value,
            items: controller.dropdownMenuItem(),
            onChanged: (value) => controller.dropDownItemChanged(value),
          ),
        ),
        15.verticalSpace,
        Obx(() => _commentField(hasComments)),
        20.verticalSpace,
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
            10.horizontalSpace,
            Expanded(
              child: FlatButtonWidget(
                width: 100.w,
                label: "Return",
                color: color,
                onTap: () {
                  if (_checkComments(hasComments)) {
                    controller.actionReturn(hasComments);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getSendBody() {
    var hasComments = controller.pendingTaskModel?.approvalcomments
                .toString()
                .toLowerCase() !=
            't'
        ? true
        : false;

    controller.getSendToUsers_List();
    return Column(
      children: [
        Visibility(
          visible: controller.pendingTaskModel!.cmsg_reject.toString() != ''
              ? true
              : false,
          child: Center(
              child: Text(
            controller.pendingTaskModel!.cmsg_appcheck.toString(),
            style: AppStyles.actionButtonStyle,
          )),
        ),
        Obx(
          () => PrimaryDropdownField(
            borderColor: color,
            value: controller.ddSendToUsers_SelectedValue.value,
            items: controller.dropdownMenuItemSendToUsers(),
            onChanged: (value) =>
                controller.dropDownItemChangedSendToUsers(value),
          ).skeletonLoading(controller.isActiveListSendUserListLoading.value),
        ),
        15.verticalSpace,
        Obx(() => _commentField(hasComments)),
        20.verticalSpace,
        Obx(
          () => Row(
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
              10.horizontalSpace,
              Expanded(
                child: FlatButtonWidget(
                  width: 100.w,
                  label: "Send",
                  color: color,
                  onTap: () {
                    if (_checkComments(hasComments)) {
                      controller.actionReturn(hasComments);
                    }
                  },
                ),
              ),
            ],
          ).skeletonLoading(controller.isActiveListSendUserListLoading.value),
        )
      ],
    );
  }

  Widget _getViewBody() {
    return Column(
      children: [
        15.verticalSpace,
        SizedBox(height: 1.sh / 2, child: _historyWebViewWidget()),
        20.verticalSpace,
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
            // 10.horizontalSpace,
            // Expanded(
            //   child: FlatButtonWidget(
            //     width: 100.w,
            //     label: "View",
            //     color: color,
            //     onTap: () {},
            //   ),
            // ),
          ],
        )
      ],
    );
  }

  Widget _getHistoryBody() {
    return Column(
      children: [
        15.verticalSpace,
        SizedBox(height: 1.sh / 2, child: _historyWebViewWidget()),
        20.verticalSpace,
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
            // 10.horizontalSpace,
            // Expanded(
            //   child: FlatButtonWidget(
            //     width: 100.w,
            //     label: "History",
            //     color: color,
            //     onTap: () {},
            //   ),
            // ),
          ],
        )
      ],
    );
  }

  Widget _getApproveBody() {
    var hasComments = controller.pendingTaskModel?.approvalcomments
                .toString()
                .toLowerCase() ==
            't'
        ? true
        : false;

    return Column(
      children: [
        Visibility(
          visible: controller.pendingTaskModel!.cmsg_reject.toString() != ''
              ? true
              : false,
          child: Center(
              child: Text(
            controller.pendingTaskModel!.cmsg_appcheck.toString(),
            style: AppStyles.actionButtonStyle,
          )),
        ),
        // Row(
        //   children: [
        //     3.horizontalSpace,
        //     Text("Comments",
        //         style: AppStyles.onboardingSubTitleTextStyle.copyWith(
        //           fontWeight: FontWeight.w400,
        //           color: AppColors.primarySubTitleTextColorBlueGreyLight,
        //         )),
        //   ],
        // ),
        5.verticalSpace,
        Obx(() => _commentField(hasComments)),
        20.verticalSpace,
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
            10.horizontalSpace,
            Expanded(
              child: FlatButtonWidget(
                width: 100.w,
                label: "Approve",
                color: color,
                onTap: () {
                  if (_checkComments(hasComments)) {
                    controller.actionApproveOrRejectOrCheck(
                        hasComments, "Approve");
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _historyWebViewWidget() {
    var urlNew =
        "aspx/AxMain.aspx?authKey=AXPERT-${controller.appStorage.retrieveValue(AppStorage.SESSIONID)}&pname=iad___pth&params=pkeyvalue~${controller.pendingTaskModel!.keyvalue}^pprocess~${controller.pendingTaskModel!.processname}";

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(
          Const.getFullWebUrl(urlNew),
        ),
      ),
      key: ValueKey("webviewHistory"),
    );
  }

  Widget _viewWebViewWidget() {
    var urlNew =
        "aspx/AxMain.aspx?authKey=AXPERT-${controller.appStorage.retrieveValue(AppStorage.SESSIONID)}&pname=t${controller.pendingTaskModel!.transid}&params=act~load^recordid~${controller.pendingTaskModel!.recordid}";

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(
          Const.getFullWebUrl(urlNew),
        ),
      ),
      key: ValueKey("webviewview"),
    );
  }

  bool _checkComments(bool hasComments) {
    if (hasComments && controller.comments.text.isEmpty) {
      AppSnackBar.showWarning("Add Comments", "Comments are Mandatory");
      return false;
    }

    return true;
  }
}
