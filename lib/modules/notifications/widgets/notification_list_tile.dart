
import 'package:flutter/material.dart';

import '../model/firebase_message_model.dart';

class NotificationTile extends StatelessWidget {
  final FirebaseMessageModel msg;

  const NotificationTile(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
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
