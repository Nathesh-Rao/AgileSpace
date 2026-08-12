import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/flat_button_widget.dart';
import '../../../core/core.dart';

class ActiveListFilterWidget extends GetView<ActiveListController> {
  const ActiveListFilterWidget({super.key});

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
              "Filter Results",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.blue10,
              ),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              "Please enable the filters you want",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                20.verticalSpace,
                CupertinoTextField(
                  suffixMode: OverlayVisibilityMode.editing,
                  padding: EdgeInsets.all(10.h),
                  placeholder: "Process Name ",
                  placeholderStyle: GoogleFonts.poppins(
                    color: AppColors.blue10.withAlpha(200),
                    fontSize: 14.sp,
                  ),
                  controller: controller.processNameController,
                  textInputAction: TextInputAction.next,
                  decoration: BoxDecoration(
                    color: AppColors.blue10.withAlpha(10),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.blue10,
                    ),
                  ),
                  suffix: IconButton(
                    onPressed: () {
                      controller.processNameController.text = "";
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: Icon(
                      CupertinoIcons.clear_circled_solid,
                      size: 20,
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text("OR",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)))),
                CupertinoTextField(
                  padding: EdgeInsets.all(10.h),
                  suffixMode: OverlayVisibilityMode.editing,
                  placeholder: "From User",
                  placeholderStyle: GoogleFonts.poppins(
                    color: AppColors.chipCardWidgetColorViolet.withAlpha(200),
                    fontSize: 14.sp,
                  ),
                  controller: controller.fromUserController,
                  textInputAction: TextInputAction.next,
                  decoration: BoxDecoration(
                    color: AppColors.chipCardWidgetColorViolet.withAlpha(10),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.chipCardWidgetColorViolet,
                    ),
                  ),
                  suffix: IconButton(
                    onPressed: () {
                      controller.fromUserController.text = "";
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: Icon(
                      CupertinoIcons.clear_circled_solid,
                      size: 20,
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text("OR",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)))),
                Obx(
                  () => CupertinoTextField(
                    padding: EdgeInsets.all(10.h),
                    suffixMode: OverlayVisibilityMode.editing,
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    placeholder: "From Date: DD-MMM-YYYY",
                    placeholderStyle: GoogleFonts.poppins(
                      color: AppColors.brownRed.withAlpha(200),
                      fontSize: 14.sp,
                    ),
                    controller: controller.dateFromController,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.next,
                    decoration: BoxDecoration(
                      color: AppColors.brownRed.withAlpha(10),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: controller.errDateFrom.value.isNotEmpty
                            ? AppColors.baseRed
                            : AppColors.brownRed,
                      ),
                    ),
                    prefix: controller.errDateFrom.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.error,
                              color: AppColors.baseRed,
                            ),
                          )
                        : null,
                    suffix: IconButton(
                      onPressed: () {
                        controller.dateFromController.text = "";
                      },
                      icon: Icon(
                        CupertinoIcons.clear_circled_solid,
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      selectDate(Get.context!, controller.dateFromController);
                    },
                  ),
                ),
                20.verticalSpace,
                Obx(
                  () => CupertinoTextField(
                    padding: EdgeInsets.all(10.h),
                    suffixMode: OverlayVisibilityMode.editing,
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    placeholder: "To Date: DD-MMM-YYYY",
                    placeholderStyle: GoogleFonts.poppins(
                      color: AppColors.brownRed.withAlpha(200),
                      fontSize: 14.sp,
                    ),
                    controller: controller.dateToController,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.next,
                    decoration: BoxDecoration(
                      color: AppColors.brownRed.withAlpha(10),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: controller.errDateTo.value.isNotEmpty
                            ? AppColors.baseRed
                            : AppColors.brownRed,
                      ),
                    ),
                    prefix: controller.errDateTo.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.error,
                              color: AppColors.baseRed,
                            ),
                          )
                        : null,
                    suffix: IconButton(
                      onPressed: () {
                        controller.dateToController.text = "";
                      },
                      icon: Icon(
                        CupertinoIcons.clear_circled_solid,
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      selectDate(Get.context!, controller.dateToController);
                    },
                  ),
                ),
                50.verticalSpace,
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: FlatButtonWidget(
                    width: 100.w,
                    label: "Reset",
                    color: AppColors.grey1bg,
                    onTap: () {
                      controller.removeFilter();
                      Get.back();
                    },
                  ),
                ),
                // Spacer(),
                20.horizontalSpace,
                Expanded(
                  child: FlatButtonWidget(
                    width: 100.w,
                    label: "Apply",
                    color: AppColors.blue10,
                    onTap: () {
                      controller.applyFilter();
                      Get.back();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    // return Dialog(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         // Title
    //         Text(
    //           "Filter results",
    //           style: TextStyle(
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold,
    //             color: AppColors.baseBlue,
    //           ),
    //           textAlign: TextAlign.center,
    //         ),

    //         const SizedBox(height: 16),

    //         // Message
    //         Text(
    //           "message",
    //           style: const TextStyle(fontSize: 16, color: Colors.black87),
    //           textAlign: TextAlign.center,
    //         ),

    //         const SizedBox(height: 24),

    //         // Buttons

    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             FlatButtonWidget(
    //               color: AppColors.baseRed,
    //               onTap: () {},
    //               label: "NO",
    //             ),
    //             // Confirm button
    //             FlatButtonWidget(
    //               color: AppColors.baseBlue,
    //               // style: ElevatedButton.styleFrom(
    //               //   backgroundColor: AppColors.baseBlue,
    //               //   foregroundColor: Colors.white,
    //               //   padding: const EdgeInsets.symmetric(
    //               //       horizontal: 24, vertical: 12),
    //               //   shape: RoundedRectangleBorder(
    //               //     borderRadius: BorderRadius.circular(12),
    //               //   ),
    //               //   elevation: 3,
    //               // ),
    //               onTap: () async {},
    //               label: "Yes",
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    // return GestureDetector(
    //   onTap: () {
    //     FocusManager.instance.primaryFocus?.unfocus();
    //   },
    //   child: Dialog(
    //     child: Padding(
    //       padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Center(
    //               child: Text(
    //                 "Filter results",
    //                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             Container(
    //                 margin: EdgeInsets.only(top: 10),
    //                 height: 1,
    //                 color: Colors.grey.withOpacity(0.6)),
    //             SizedBox(height: 20),
    //             TextField(
    //               controller: controller.processNameController,
    //               textInputAction: TextInputAction.next,
    //               decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: Colors.grey.withOpacity(0.05),
    //                   suffix: GestureDetector(
    //                       onTap: () {
    //                         controller.processNameController.text = "";
    //                         FocusManager.instance.primaryFocus?.unfocus();
    //                       },
    //                       child: Container(
    //                         child: Text("X"),
    //                       )),
    //                   border: OutlineInputBorder(
    //                       borderSide: BorderSide(width: 1),
    //                       borderRadius: BorderRadius.circular(10)),
    //                   hintText: "Process Name "),
    //             ),
    //             Center(
    //                 child: Padding(
    //                     padding: EdgeInsets.only(top: 10, bottom: 10),
    //                     child: Text("OR",
    //                         style: TextStyle(fontWeight: FontWeight.bold)))),
    //             TextField(
    //               controller: controller.fromUserController,
    //               decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: Colors.grey.withOpacity(0.05),
    //                   suffix: GestureDetector(
    //                       onTap: () {
    //                         controller.fromUserController.text = "";
    //                         FocusManager.instance.primaryFocus?.unfocus();
    //                       },
    //                       child: Container(
    //                         child: Text("X"),
    //                       )),
    //                   border: OutlineInputBorder(
    //                       borderSide: BorderSide(width: 1),
    //                       borderRadius: BorderRadius.circular(10)),
    //                   hintText: "From User "),
    //             ),
    //             Center(
    //                 child: Padding(
    //                     padding: EdgeInsets.only(top: 10, bottom: 10),
    //                     child: Text("OR",
    //                         style: TextStyle(fontWeight: FontWeight.bold)))),
    //             TextField(
    //               controller: controller.dateFromController,
    //               textAlign: TextAlign.center,
    //               decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: Colors.grey.withOpacity(0.05),
    //                   suffix: GestureDetector(
    //                       onTap: () {
    //                         controller.dateFromController.text = "";
    //                       },
    //                       child: Container(
    //                         child: Text("X"),
    //                       )),
    //                   border: OutlineInputBorder(
    //                       borderSide: BorderSide(width: 1),
    //                       borderRadius: BorderRadius.circular(10)),
    //                   // errorText: errText(errDateFrom.value),
    //                   hintText: "From Date: DD-MMM-YYYY "),
    //               canRequestFocus: false,
    //               onTap: () {
    //                 // selectDate(Get.context!, controller.dateFromController);
    //               },
    //               enableInteractiveSelection: false,
    //             ),
    //             SizedBox(height: 5),
    //             TextField(
    //               controller: controller.dateToController,
    //               textAlign: TextAlign.center,
    //               decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: Colors.grey.withOpacity(0.05),
    //                   suffix: GestureDetector(
    //                       onTap: () {
    //                         controller.dateToController.text = "";
    //                       },
    //                       child: Container(
    //                         child: Text("X"),
    //                       )),
    //                   border: OutlineInputBorder(
    //                       borderSide: BorderSide(width: 1),
    //                       borderRadius: BorderRadius.circular(10)),
    //                   // errorText: errText(errDateTo.value),
    //                   hintText: "To Date: DD-MMM-YYYY"),
    //               canRequestFocus: false,
    //               enableInteractiveSelection: false,
    //               onTap: () {
    //                 // selectDate(Get.context!, dateToController);
    //               },
    //             ),
    //             SizedBox(height: 20),
    //             Container(
    //               height: 1,
    //               color: Colors.grey.withOpacity(0.4),
    //             ),
    //             SizedBox(height: 10),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 TextButton(
    //                     onPressed: () {
    //                       // removeFilter();
    //                       Get.back();
    //                     },
    //                     child: Text("Reset")),
    //                 ElevatedButton(
    //                     onPressed: () {
    //                       // _parseTaskMap();
    //                       Get.back();
    //                     },
    //                     child: Text("Filter"))
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  errText(String value) {
    if (value == "") {
      return null;
    } else {
      return value;
    }
  }

  void selectDate(BuildContext context, TextEditingController text) async {
    FocusManager.instance.primaryFocus?.unfocus();
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now());
    if (picked != null) {
      text.text =
          "${picked.day.toString().padLeft(2, '0')}-${months[picked.month - 1]}-${picked.year.toString().padLeft(2, '0')}";
    }
  }
}
