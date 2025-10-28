import 'package:axpert_space/core/config/config.dart';
import 'package:axpert_space/modules/active_list/controller/active_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/active_list_model.dart';

class WidgetActiveLisTile extends GetView<ActiveListController> {
  const WidgetActiveLisTile({super.key, required this.model});
  final ActiveTaskListModel model;

  @override
  Widget build(BuildContext context) {
    var style = GoogleFonts.poppins();
    var color = model.cstatus?.toLowerCase() == "active"
        ? Color(0xff9898FF)
        : Color(0xff319F43);

    return ListTile(
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
            color: model.cstatus?.toLowerCase() == "active"
                ? Color(0xff9898FF)
                : null,
            width: 5,
          ),
          CircleAvatar(
            radius: 23,
            backgroundColor: color.withAlpha(70),
            child: Icon(
              model.cstatus?.toLowerCase() == "active"
                  ? Icons.file_open_rounded
                  : Icons.done,
              color: color,
            ),
          ),
        ],
      ),
      title: controller.highlightedText(model.displaytitle.toString(),
          style.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          isTitle: true),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.highlightedText(
            model.displaycontent.toString().trim(),
            style.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _tileInfoWidget(model.fromuser.toString(), Color(0xff737674)),
              SizedBox(width: 10),
              model.cstatus?.toLowerCase() != "active"
                  ? _tileInfoWidget(model.cstatus.toString(), Color(0xff319F43))
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
            controller.formatToDayTime(model.eventdatetime.toString()),
          ),
        ),
      ),
    );
  }

  _tileInfoWidget(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
          color: color.withAlpha(50), borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 10, color: color, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
