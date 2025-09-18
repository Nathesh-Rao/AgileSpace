import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/colors/app_colors.dart';
import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.message});
  final FirebaseMessageModel message;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Color(0xffDA5077).withAlpha(50),
          foregroundColor: Color(0xffDA5077),
          child: Icon(CupertinoIcons.bell_solid)),
      title: Text(
        message.title,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        message.body,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryTitleTextColorBlueGrey,
        ),
      ),
    );
  }
}
