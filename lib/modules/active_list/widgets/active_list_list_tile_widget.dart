import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/core/utils/utils.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:axpert_space/modules/active_list/model/active_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/common.dart';

class ActiveListListTileWidget extends GetView<ActiveListController> {
  const ActiveListListTileWidget(
      {super.key, required this.title, required this.currentList});
  final List<ActiveTaskListModel> currentList;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        listTileTheme: ListTileThemeData(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5),
        child: ExpansionTile(
          key: ValueKey(title),
          // controller: controller.taskFilterExpandController,
          expansionAnimationStyle: AnimationStyle(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeIn,
          ),
          showTrailingIcon: true,

          dense: true,
          initiallyExpanded: true,
          // childrenPadding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          backgroundColor:
              controller.getColorFromTaskTitle(title).withAlpha(20),
          collapsedBackgroundColor:
              controller.getColorFromTaskTitle(title).withAlpha(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            // side: BorderSide(
            //   color: controller.getColorFromTaskTitle(title).withAlpha(50),
            // ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(
              color: controller.getColorFromTaskTitle(title).withAlpha(50),
            ),
          ),
          iconColor: controller.getColorFromTaskTitle(title),
          collapsedIconColor: controller.getColorFromTaskTitle(title),
          title: Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: controller.getColorFromTaskTitle(title)),
          ),

          subtitle: Row(
            children: [
              Text(
                "${currentList.length} tasks",
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: AppColors.text1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          children: [
            Divider(
              color: controller.getColorFromTaskTitle(title),
              height: 1,
            ),
            Container(
              color: Colors.white,
              height: 10.h,
            ),
            ...List.generate(
                currentList.length, (index) => _listTile(currentList[index])),
            Container(
              color: Colors.white,
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  _listTile(ActiveTaskListModel l) {
    var style = GoogleFonts.poppins();
    var color = l.cstatus?.toLowerCase() == "active"
        ? AppColors.chipCardWidgetColorViolet
        : AppColors.chipCardWidgetColorGreen;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border(
        //   bottom: BorderSide(color: color.withAlpha(20), width: 1),
        // ),
      ),
      child: ListTile(
        onTap: () {
          controller.onTaskClick(l);
        },
        isThreeLine: true,
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: color.withAlpha(30),
          child: Center(
            child: Icon(
              l.cstatus?.toLowerCase() == "active"
                  ? Icons.file_open_rounded
                  : Icons.done,
              color: color,
              size: 18,
            ),
          ),
        ),
        title: controller.highlightedText(l.displaytitle.toString(),
            style.copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp),
            isTitle: true),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.highlightedText(
              l.displaycontent.toString().trim(),
              style.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 8.sp,
                color: AppColors.primaryTitleTextColorBlueGrey,
              ),
            ),
            10.verticalSpace,
            Row(
              children: [
                ChipCardWidget(
                    label: l.fromuser.toString(),
                    color: AppColors.primaryButtonBGColorViolet),
                SizedBox(width: 10),
                l.cstatus?.toLowerCase() != "active"
                    ? ChipCardWidget(
                        label: l.cstatus.toString(), color: Color(0xff319F43))
                    : SizedBox.shrink(),
              ],
            ),
            7.verticalSpace,
          ],
        ),
        trailing: RichText(
          text: TextSpan(
            style: style.copyWith(
              fontSize: 9,
              color: AppColors.primaryTitleTextColorBlueGrey,
              // color: Color(0xff666D80),
              fontWeight: FontWeight.w600,
            ),
            children: controller.formatDateTimeSpan(
              controller.formatToDayTime(l.eventdatetime.toString()),
            ),
          ),
        ),

        // trailing: Text(controller.formatSmartDateTime(
        //     DateFormat("dd/MM/yyyy HH:mm:ss")
        //         .parse(l.eventdatetime.toString()))),
      ),
    );

    return ListTile(
      tileColor: Colors.white,
      contentPadding: EdgeInsets.only(left: 0, right: 10, top: 5),
      titleAlignment: ListTileTitleAlignment.center,
      isThreeLine: true,
      shape: Border(
          bottom: BorderSide(color: AppColors.floatButtonBaseColorBlueGray)),
      onTap: () {
        // controller.onTaskClick(model);
      },
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 25,
            ),
            color:
                l.cstatus?.toLowerCase() == "active" ? Color(0xff9898FF) : null,
            width: 5,
          ),
          CircleAvatar(
            radius: 23,
            backgroundColor: color.withAlpha(70),
            child: Icon(
              l.cstatus?.toLowerCase() == "active"
                  ? Icons.file_open_rounded
                  : Icons.done,
              color: color,
            ),
          ),
        ],
      ),
      title: controller.highlightedText(l.displaytitle.toString(),
          style.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          isTitle: true),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.highlightedText(
            l.displaycontent.toString().trim(),
            style.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ChipCardWidget(
                  label: l.fromuser.toString(), color: Color(0xff737674)),
              SizedBox(width: 10),
              l.cstatus?.toLowerCase() != "active"
                  ? ChipCardWidget(
                      label: l.cstatus.toString(), color: Color(0xff319F43))
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 7),
        ],
      ),
      trailing: RichText(
        text: TextSpan(
          style: style.copyWith(
            fontSize: 9,
            color: AppColors.baseGray,
            // color: Color(0xff666D80),
            fontWeight: FontWeight.w600,
          ),
          children: controller.formatDateTimeSpan(
            controller.formatToDayTime(l.eventdatetime.toString()),
          ),
        ),
      ),
    );
  }
}
