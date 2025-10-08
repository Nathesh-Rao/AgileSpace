import 'package:auto_size_text/auto_size_text.dart';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/news_events/controller/news_events_controller.dart';
import 'package:axpert_space/modules/news_events/models/announcement_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
        SizedBox(
          height: 265.h,
          child: Stack(
            children: [
              PageView.builder(
                controller: controller.pageController,
                scrollDirection: Axis.vertical,
                itemCount: controller.announcementList.length,
                itemBuilder: (context, index) =>
                    newsEventTile(controller.announcementList[index]),
                onPageChanged: (v) {
                  controller.currentIndex.value = v;
                },
              ),
              Positioned(
                right: 20.w,
                top: 80.h,
                child: _pageIndicator(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget newsEventTile(AnnouncementModel announcement) => Container(
        height: 265.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              width: 0.5.w,
              color: AppColors.brownRed,
            )),
        child: Column(
          children: [
            Container(
              height: 182.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.none,
                    image: AssetImage(announcement.image),
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
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 21,
                            backgroundImage: AssetImage(
                                "assets/icons/common/profile_female.png"),
                          ),
                        ),
                        10.horizontalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcement.op,
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryButtonFGColorWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              announcement.opDesignation,
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
                          announcement.caption,
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
                                  DateTime.now().toString())
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
                              DateTime.now().toString()),
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
                                "Office - Bangalore",
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
                              "Notice of position for “Marsha Leanetha” from Jr. Backend developer becomes Sr. Backend developer following is the attachment to the letter",
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
      decoration: BoxDecoration(
        color: AppColors.primaryButtonFGColorWhite.withAlpha(50),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) => _indicatorWidget(index: index)),
      ),
    );
  }

  _indicatorWidget({required int index}) {
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
}
