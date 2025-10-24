import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_details_controller.dart';
import 'package:axpert_space/modules/web_view/screen/inapp_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';

class ActiveListDetailsBodyWidget extends GetView<ActiveListDetailsController> {
  const ActiveListDetailsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => controller.selected_processFlow_taskType.toUpperCase() == "MAKE"
            ? InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri(Const.getFullWebUrl(
                        ServerConnections.activeList_CreateURL_MAKE(
                  controller.openModel,
                )))),
                key: ValueKey("webview"),
              )
            : Visibility(
                visible: controller.pendingTaskModel != null,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h),
                  child: Column(children: [
                    Row(
                      children: [
                        Text("Ticket : ",
                            style: AppStyles.appBarTitleTextStyle),
                        Text(
                            controller.pendingTaskModel != null
                                ? '#${controller.pendingTaskModel!.taskid}'
                                : '',
                            style: AppStyles.appBarTitleTextStyle.copyWith(
                              color: AppColors.primaryActionColorDarkBlue,
                            )),
                        Spacer(),
                        ChipCardWidget(
                            onMaxSize: true,
                            label: controller.pendingTaskModel != null
                                ? controller.pendingTaskModel!.tasktype
                                : '',
                            color: (controller.pendingTaskModel?.tasktype ?? '')
                                    .toLowerCase()
                                    .contains("approve")
                                ? AppColors.baseYellow
                                : AppColors.chipCardWidgetColorGreen)
                      ],
                    ),
                    25.verticalSpace,
                    _bodyInfoTile(
                      label: "Pending Approvel :",
                      value: controller.pendingTaskModel != null
                          ? controller.pendingTaskModel!.touser.capitalize ?? ''
                          : '',
                      icon: Icon(
                        Icons.info,
                        color: AppColors.baseYellow,
                        size: 16.sp,
                      ),
                    ),
                    _bodyInfoTile(
                      label: "Raised By :",
                      value: controller.pendingTaskModel != null
                          ? controller.pendingTaskModel!.fromuser.capitalize ??
                              ''
                          : '',
                      icon: Icon(
                        Icons.person_4,
                        color: AppColors.chipCardWidgetColorRed,
                        size: 16.sp,
                      ),
                    ),
                    _bodyInfoTile(
                      label: "Assigned By :",
                      value: controller.pendingTaskModel != null
                          ? controller.pendingTaskModel!.initiator.capitalize ??
                              ''
                          : '',
                      icon: Icon(
                        Icons.person_3,
                        color: AppColors.chipCardWidgetColorViolet,
                        size: 16.sp,
                      ),
                    ),
                    _bodyInfoTile(
                      label: "Assigned On :",
                      value: controller.pendingTaskModel != null
                          ? controller.getDateValue(
                              controller.pendingTaskModel!.eventdatetime)
                          : '',
                      icon: Icon(
                        Icons.edit_calendar,
                        color: AppColors.chipCardWidgetColorGreen,
                        size: 16.sp,
                      ),
                    ),
                    // _bodyInfoTile(
                    //   label: "Description :",
                    //   value: controller.pendingTaskModel != null
                    //       ? controller.pendingTaskModel!.displaycontent
                    //                   .toLowerCase() !=
                    //               'null'
                    //           ? controller.pendingTaskModel!.displaycontent
                    //               .toString()
                    //           : ' '
                    //       : "",
                    //   icon: Icon(
                    //     Icons.text_snippet_sharp,
                    //     color: AppColors.grey1bg,
                    //     size: 16.sp,
                    //   ),
                    // ),
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.text_snippet_sharp,
                          color: AppColors.grey1bg,
                          size: 16.sp,
                        ),
                        5.horizontalSpace,
                        Flexible(
                          child: Text(
                            "Description :",
                            style: AppStyles.actionButtonStyle.copyWith(
                              color: AppColors.primaryTitleTextColorBlueGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            controller.pendingTaskModel != null
                                ? controller.pendingTaskModel!.displaycontent
                                            .toLowerCase() !=
                                        'null'
                                    ? controller
                                        .pendingTaskModel!.displaycontent
                                        .toString()
                                    : ' '
                                : "",
                            style: AppStyles.actionButtonStyle,
                          ),
                        ),
                      ],
                    )
                  ]),
                ).skeletonLoading(controller.isActiveListDetailsLoading.value),
              ),
      ),
    );
  }

  Widget _bodyInfoTile(
      {required String label, required String value, required Icon icon}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                5.horizontalSpace,
                Flexible(
                  child: Text(
                    label,
                    style: AppStyles.actionButtonStyle.copyWith(
                      color: AppColors.primaryTitleTextColorBlueGrey,
                    ),
                  ),
                ),
              ],
            )),
            10.horizontalSpace,
            Expanded(
              child: Text(
                value,
                style: AppStyles.actionButtonStyle,
              ),
            )
          ],
        ),
        5.verticalSpace,
        Divider(
          color: icon.color?.withAlpha(20),
        ),
        10.verticalSpace,
      ],
    );
  }
}
