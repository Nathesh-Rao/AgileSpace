import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const primaryTitleTextColorBlueGrey = Color(0xff505B77);
  static const primarySubTitleTextColorBlueGreyLight = Color(0xff969DAD);
  static const secondarySubTitleTextColorGreyLight = Color(0xffA2A2A2);

  static const primaryButtonBGColorViolet = Color(0xff544D80);
  static const primaryButtonFGColorWhite = Color(0xffE9EDF2);
  static const secondaryButtonBGColorWhite = Colors.white;
  static const secondaryButtonFGColorViolet = primaryButtonBGColorViolet;
  static const secondaryButtonBorderColorGrey = Color(0xffDDDDDD);
  static const normalBoxBorderColorGrey = Color(0xffCCCCCC);
  static const textFieldMainTextColorBlueGrey = Color(0xff757575);

  static const primaryActionColorDarkBlue = Color(0xff282D46);

  static const otpFieldThemeColorGreen = Color(0xff5BBBA9);

  static const snackBarInfoColorGrey = Color(0xff9E9E9E);
  static const snackBarNotificationColorBlue = Color(0xffA1BAFF);
  static const snackBarSuccessColorGreen = Color(0xff80DCB9);
  static const snackBarWarningColorYellow = Color(0xffFFC786);
  static const snackBarErrorColorRed = Color(0xffF1AA9B);

  static const primaryActionIconColorBlue = Color(0xff2A79E4);

  static const taskClockInWidgetColorPurple = Color(0xff8371EC);

  static const primarySearchFieldBGColorGrey = Color(0xffF5F5F5);

  static const chipCardWidgetColorViolet = Color(0xff8E61E9);
  static const chipCardWidgetColorRed = Color(0xffE96161);
  static const chipCardWidgetColorGreen = Color(0xff01916A);
  static const chipCardWidgetColorBlue = Color(0xff2A79E4);

  static const Color statusPending = Colors.deepOrange;
  static const Color statusInProgress = Colors.blueAccent;
  static const Color statusCompleted = Colors.green;

  static const Color priorityHigh = Colors.redAccent;
  static const Color priorityMedium = Colors.amber;
  static const Color priorityLow = Colors.green;

  static const Color historyCreated = Color(0xffFB6340);
  static const Color historyAssigned = Color(0xff2A79E4);
  static const Color historyCompleted = Color(0xff2DCE89);

  static const flatButtonColorBlue = Color(0xff2A79E4);
  static const flatButtonColorPurple = Color(0xff8371EC);

  static Color getHistoryColor(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return historyCreated;
      case 'reassigned':
        return historyAssigned;
      case 'completed':
        return historyCompleted;
      default:
        return historyCreated;
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return statusPending;
      case 'in_progress':
        return statusInProgress;
      case 'completed':
        return statusCompleted;
      default:
        return Colors.grey;
    }
  }

  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return priorityHigh;
      case 'medium':
        return priorityMedium;
      case 'low':
        return priorityLow;
      default:
        return Colors.grey;
    }
  }
}
