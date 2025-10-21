import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/common.dart';
import '../../../common/widgets/empty_widget.dart';
import '../widgets/active_list_search_field.dart';
import '../widgets/active_list_tile_widget.dart';

class ActiveListScreen extends GetView<ActiveListController> {
  const ActiveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init();
    });

    return Scaffold(
      backgroundColor: AppColors.secondaryButtonBGColorWhite,
      floatingActionButton: _floatingActionButton(),
      appBar: AppBar(
        title: Text("Active list"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 10, left: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimarySearchFieldWidget(
                    controller: controller.searchTextController,
                    onChanged: controller.searchTask,
                    onSuffixTap: controller.clearSearch,
                  ),
                  // Obx(() => _iconButtons(
                  //       Icons.filter_alt,
                  // controller.openFilterPrompt,
                  //   () {},
                  //   isActive: controller.isFilterOn.value,
                  // )),
                  // _iconButtons(Icons.select_all_rounded, () {}),
                  // _iconButtons(Icons.done_all, () async {
                  // pendingListController.bulkCommentController.clear();
                  // await pendingListController.getBulkApprovalCount();
                  // Get.dialog(WidgetActiveListBulkApprovalDialog());
                  // }),

                  IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.done_all))
                ],
              ),
            ),
            Expanded(
                child: Obx(
              () => Visibility(
                visible: controller.activeTaskMap.keys.isNotEmpty,
                child: ListView(
                  controller: controller.taskListScrollController,
                  // padding: EdgeInsets.only(top: 20),
                  physics: BouncingScrollPhysics(),
                  children: List.generate(
                    controller.activeTaskMap.keys.length,
                    (index) {
                      var key = controller.activeTaskMap.keys.toList()[index];
                      var currentList = controller.activeTaskMap[key];

                      return ExpandedTile(
                        contentseparator: 0,
                        theme: ExpandedTileThemeData(
                          titlePadding: EdgeInsets.all(0),
                          contentPadding: EdgeInsets.all(0),
                          headerColor: AppColors.grey2,
                          headerSplashColor: AppColors.grey1,
                          contentBackgroundColor: Colors.white,
                          contentSeparatorColor: Colors.white,
                        ),
                        controller: ExpandedTileController(isExpanded: true),
                        title: Text(
                          key.toString(),
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        content: Column(
                          children: List.generate(
                              currentList!.length,
                              (i) =>
                                  WidgetActiveLisTile(model: currentList[i])),
                        ),
                        onTap: () {
                          // debugPrint("tapped!!");
                        },
                        onLongTap: () {
                          // debugPrint("long tapped!!");
                        },
                      );
                    },
                  ),
                ),
              ),
            )),
            _bottomTextInfoWidget(),
          ],
        ),
      ),
    );
  }

  Widget _iconButtons(IconData icon, Function() onTap,
      {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 10),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          border: isActive ? Border.all(color: AppColors.blue9) : null,
          color: isActive ? null : Color(0xffF1F1F1).withBlue(250),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? AppColors.blue9 : AppColors.snackBarInfoColorGrey,
          ),
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return Obx(
      () => controller.activeTaskList.isEmpty
          ? EmptyWidget(
              label: "No Task Data Available",
            )
          : FloatingActionButton(
              backgroundColor: AppColors.blue9,
              foregroundColor: AppColors.primaryButtonFGColorWhite,
              onPressed: controller.refreshList,
              child: controller.isListLoading.value
                  ? Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryButtonFGColorWhite,
                            strokeWidth: 2,
                            strokeCap: StrokeCap.round,
                          )),
                    )
                  : Icon(controller.isRefreshable.value
                      ? Icons.refresh_rounded
                      : Icons.arrow_upward_rounded),
            ),
    );
  }

  Widget _bottomTextInfoWidget() {
    return Obx(() => controller.showFetchInfo.value
        ? Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "No more records to display",
              style: GoogleFonts.poppins(
                color: AppColors.baseRed,
              ),
            ),
          )
        : SizedBox.shrink());
  }
}
