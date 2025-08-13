import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/leaves/leaves.dart';
import 'package:axpert_space/modules/leaves/models/leave_activity_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';

class LeaveDashBoardEventUpcomingWidget extends GetView<LeaveController> {
  const LeaveDashBoardEventUpcomingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CarouselSlider(
      options: CarouselOptions(
        height: 500.h,
        autoPlay: true,
        scrollDirection: Axis.vertical,
        reverse: true,
      ),
      items: controller.leaveActivity.value?.upcomingLeave.map((leave) {
        return Builder(
          builder: (BuildContext context) {
            return _upcomingEventTile(leave);
          },
        );
      }).toList(),
    ));
  }

  // _upcomingWidget() => Expanded(
  //       child: _baseContainer(
  //         Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(5),
  //                   child: Icon(
  //                     Icons.upcoming,
  //                     size: 15.w,
  //                     color: AppColors.leaveWidgetColorGreen,
  //                   ),
  //                 ),
  //                 Text(
  //                   "Upcoming & Approved Leaves",
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 8.sp,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Expanded(
  //               child: CarouselSlider(
  //                 options: CarouselOptions(
  //                   height: 500,
  //                   autoPlay: true,
  //                   scrollDirection: Axis.vertical,
  //                 ),
  //                 items: controller.leaveActivity.value?.upcomingLeave.map((i) {
  //                   return Builder(
  //                     builder: (BuildContext context) {
  //                       return _upcomingEventTile();
  //                     },
  //                   );
  //                 }).toList(),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     );

  _upcomingEventTile(UpcomingLeave leave) => Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: AppColors.leaveWidgetColorGreenLite,
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5.h),
                decoration: BoxDecoration(
                  color: AppColors.leaveWidgetColorGreen,
                  borderRadius: BorderRadius.circular(5.sp),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateUtilsHelper.getDateNumber(leave.date),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        DateUtilsHelper.getShortDayName(leave.date),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
                flex: 2,
                child: Column(
                  spacing: 4.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total approved: ${leave.daysNo} days",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 6.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      leave.approvedBy,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      leave.leaveType,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 6.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      );
  //
  // Widget _baseContainer(Widget child) => Container(
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(10.r),
  //           border: Border.all(
  //             color: AppColors.secondaryButtonBorderColorGrey,
  //           )),
  //       child: child,
  //     );
}
