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
  static const Color statusAccepted = Colors.indigo;
  static const Color statusForwarded = Colors.blue;
  static const Color statusReassigned = Colors.teal;

  static const Color priorityHigh = Colors.redAccent;
  static const Color priorityMedium = Colors.amber;
  static const Color priorityLow = Colors.green;

  static const Color historyCreated = Color(0xffFB6340);
  static const Color historyAssigned = Color(0xff2A79E4);
  static const Color historyCompleted = Color(0xff2DCE89);

  static const flatButtonColorBlue = Color(0xff2A79E4);
  static const flatButtonColorPurple = Color(0xff8371EC);

  static const leaveWidgetColorSandal = Color(0xffE0A47A);
  static const leaveWidgetColorGreen = Color(0xff379785);
  static const leaveWidgetColorPink = Color(0xffDA5077);
  static const leaveWidgetColorGreenLite = Color(0xff5BBBA9);

  static Color getHistoryColor(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return historyCreated;
      case 'reassigned':
        return historyAssigned;
      case 'completed':
        return historyCompleted;
      case 'forwarded':
        return historyAssigned;
      case 'accepted':
        return historyCompleted;
      case 'closed':
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
      case 'reassigned':
        return statusReassigned;
      case 'accepted':
        return statusAccepted;
      case 'forwarded':
        return statusForwarded;
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

  static final List<Color> _colorPalette = [
    Color(0xFF8371EC),
    Color(0xFFFF9B00),
    Color(0xFF0271F2),
    Color(0xFF9764DA),
    Color(0xFF3764FC),
    Color(0xFF9C27B0),
    Color(0xFF9764DA),
    Color(0xFF0271F2),
    Color(0xFFFF9B00),
    Color(0xFF8371EC),
  ];

  static int _currentIndex = 0;

  static var gradientBlue = Color(0xFF3764FC);

  static var gradientViolet = Color(0xFF9764DA);

  static var violetBorder = Color(0xff8371EC);

  static Color getNextColor() {
    if (_currentIndex >= _colorPalette.length) {
      _currentIndex = 0;
    }
    return _colorPalette[_currentIndex++];
  }

  static void resetColorIndex() {
    _currentIndex = 0;
  }

  static const Color baseBlue = Color(0xff3764FC);
  static const Color baseYellow = Color(0xffF79E02);
  static const Color baseRed = Color(0xffDD2025);
  static const Color baseGray = Color(0xffDEDEDE);
  static const Color text1 = Color(0xff626262);
  static const Color text2 = Color(0xff919191);
  static const Color blue9 = Color(0xFF0d297d);
  static const Color blue10 = Color(0xff1F41BB);
  static const LinearGradient subBGGradientVertical =
      LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
    Color(0xff3764FC),
    Color(0xff9764DA),
  ]);

  static const LinearGradient subBGGradientHorizontal = LinearGradient(colors: [
    Color(0xff3764FC),
    Color(0xff9764DA),
  ]);
}
