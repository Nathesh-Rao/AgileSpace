import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/empty_widget.dart';
import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/news_events/controller/news_events_controller.dart';
import 'package:axpert_space/modules/news_events/models/announcement_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class NewsEventsDashboardWidget extends GetView<NewsEventsController> {
  const NewsEventsDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getInitialData();
    });

    return Column(
      children: [
        IconLabelWidget(
            iconColor: AppColors.brownRed, label: "News and Events"),
        10.verticalSpace,
        // CarouselSlider.builder(
        //     itemCount: 5,
        //     itemBuilder: (context, index, index2) => newsEventTile(),
        //     options: CarouselOptions(
        //       height: 265.h,
        //       pageSnapping: false,
        //       scrollDirection: Axis.vertical,
        //     )),
        Obx(
          () => SizedBox(
            height: context.isTablet ? 465.h : 265.h,
            child: controller.announcementList.isEmpty
                ? _emptyWidget()
                : Stack(
                    children: [
                      PageView.builder(
                        controller: controller.pageController,
                        scrollDirection: Axis.vertical,
                        itemCount: controller.announcementList.length,
                        itemBuilder: (context, index) => newsEventTile(
                            controller.announcementList[index], context),
                        onPageChanged: (v) {
                          controller.currentIndex.value = v;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _pageIndicator(),
                      ),
                    ],
                  ),
          ).skeletonLoading(controller.isEventsLoading.value),
        )
      ],
    );
  }

  Widget newsEventTile(AnnouncementModel announcement, BuildContext context) =>
      Container(
        height: context.isTablet ? 415.h : 265.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              width: 0.5.w,
              color: AppColors.brownRed,
            )),
        child: Column(
          children: [
            Container(
              height: context.isTablet ? 332.h : 182.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.none,
                    image: AssetImage(controller
                        .getImageFromEventType(announcement.eventType)),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                children: [
                  Container(
                    height: 182.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.black.withAlpha(100),
                    ),
                  ),
                  Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r)),
                      color: Colors.black26,
                    ),
                    child: Center(
                        child: Row(
                      children: [
                        10.horizontalSpace,
                        // Text(
                        //   "This Month",
                        //   style: GoogleFonts.poppins(
                        //     color: Color(0xffFABB18),
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    )),
                  ),
                  Positioned(
                    top: 20.h,
                    left: 20.w,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22.r,
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.baseBlue,
                          child: CircleAvatar(
                            radius: 21.r,
                            // backgroundImage: AssetImage(
                            //     "assets/icons/common/.png"),
                            child: Icon(Symbols.person_filled_rounded),
                          ),
                        ),
                        10.horizontalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcement.employee.capitalize ??
                                  announcement.employee,
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryButtonFGColorWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              announcement.designation,
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryButtonFGColorWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 130.h,
                    left: 20.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          announcement.eventType,
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryButtonFGColorWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                        ),
                        // Icon(
                        //   Icons.announcement_outlined,
                        //   color: Colors.white,
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Center(
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    20.horizontalSpace,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          // "DEC",
                          DateUtilsHelper.getShortMonthName(
                                  DateUtilsHelper.convertToIso(
                                      announcement.eventDate))
                              .toUpperCase(),
                          style: GoogleFonts.poppins(
                            height: 1.1,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.brownRed,
                          ),
                        ),
                        Text(
                          DateUtilsHelper.getDateNumber(
                              DateUtilsHelper.convertToIso(
                                  announcement.eventDate)),
                          style: GoogleFonts.poppins(
                            height: 1.1,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brownRed,
                          ),
                        )
                      ],
                    ),
                    10.horizontalSpace,
                    VerticalDivider(
                      color: AppColors.brownRed,
                      indent: 10.h,
                      endIndent: 10.h,
                    ),
                    10.horizontalSpace,
                    SizedBox(
                      width: 1.sw - 150,
                      height: 70,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.location,
                                size: 15.w,
                              ),
                              8.horizontalSpace,
                              Text(
                                announcement.location,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          5.verticalSpace,
                          Flexible(
                            child: AutoSizeText(
                              announcement.message,
                              maxFontSize: 10,
                              minFontSize: 8,
                              style: GoogleFonts.poppins(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _pageIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
      margin: EdgeInsets.only(right: 20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryButtonFGColorWhite.withAlpha(50),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(controller.announcementList.length,
            (index) => _indicatorWidget(index: index)),
      ),

      // child: Obx(
      //   () => FlipInX(
      //     key: ValueKey("${controller.currentIndex.value}-value"),
      //     duration: Duration(milliseconds: 300),
      //     curve: Curves.easeIn,
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Container(
      //           width: 5.w,
      //           height: 5.w,
      //           margin: EdgeInsets.symmetric(vertical: 5.w),
      //           decoration: BoxDecoration(
      //             // shape: BoxShape.circle,
      //             borderRadius: BorderRadius.circular(100),
      //             color: AppColors.primaryButtonFGColorWhite,
      //           ),
      //         ),
      //         Container(
      //           width: 17.w,
      //           height: 17.w,
      //           decoration: BoxDecoration(
      //             // shape: BoxShape.circle,
      //             borderRadius: BorderRadius.circular(100),
      //             color: AppColors.primaryButtonFGColorWhite,
      //           ),
      //           child: Center(
      //             child: Text(
      //               (controller.currentIndex.value + 1).toString(),
      //               style: AppStyles.appBarTitleTextStyle.copyWith(
      //                   fontSize: 7.sp,
      //                   color: AppColors.baseRed,
      //                   fontWeight: FontWeight.bold),
      //             ),
      //           ),
      //         ),
      //         Container(
      //           width: 5.w,
      //           height: 5.w,
      //           margin: EdgeInsets.symmetric(vertical: 5.w),
      //           decoration: BoxDecoration(
      //             // shape: BoxShape.circle,
      //             borderRadius: BorderRadius.circular(100),
      //             color: AppColors.primaryButtonFGColorWhite,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Obx _indicatorWidget({required int index}) {
    return Obx(
      () {
        var isActive = index == controller.currentIndex.value;
        var height = isActive ? 12.w : 5.w;
        var margin = isActive ? 3.5.h : 2.5.h;
        var color =
            isActive ? AppColors.baseRed : AppColors.primaryButtonFGColorWhite;
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          width: 5.w,
          height: height,
          margin: EdgeInsets.symmetric(vertical: margin),
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(100),
            color: color,
          ),
        );
      },
    );
  }

  Widget _emptyWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey1.withAlpha(50),
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Center(
          child: EmptyWidget(
        label: "No events found for this month",
      )),
    );
  }
}
