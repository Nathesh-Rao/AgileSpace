import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/firebase_message_model.dart';
import 'notification_list_tile.dart';

class NotificationSetionBlock extends StatelessWidget {
  final String title;
  final List<FirebaseMessageModel> list;

  const NotificationSetionBlock(this.title, this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 15.w,
          ),
          child: Text(
            title,
            style: AppStyles.textButtonStyle,

            //  TextStyle(
            //   fontSize: 17,
            //   fontWeight: FontWeight.w600,
            //   color: AppColors.text1,
            // ),
          ),
        ),
        ...list.map((msg) => NotificationTile(msg)),
        SizedBox(height: 10),
      ],
    );
  }
}
