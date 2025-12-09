import 'package:axpert_space/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/firebase_message_model.dart';

class NotificationTile extends StatelessWidget {
  final FirebaseMessageModel msg;

  const NotificationTile(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {






    
    return ListTile(
      isThreeLine: true,
      title: Text(
        msg.title,
        style: AppStyles.leaveActivityMainStyle.copyWith(fontSize: 14.sp),
      ),
      subtitle: Text(
        msg.body,
        style: AppStyles.searchFieldTextStyle
            .copyWith(fontSize: 12.sp, color: AppColors.text1),
      ),
      leading: CircleAvatar(
        backgroundColor:
            AppColors.getColorByNotificationType(msg.type.toLowerCase()),
      ),
    );

    return Container(
      padding: EdgeInsets.all(14),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(msg.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              )),
          SizedBox(height: 4),
          Text(
            msg.body,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
