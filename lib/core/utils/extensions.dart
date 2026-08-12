import 'package:flutter/material.dart';

import '../../common/common.dart';

// extension DeviceInfoExt on BuildContext {
//   Size get screenSize => MediaQuery.of(this).size;

//   double get shortestSide {
//     final size = screenSize;
//     return size.width < size.height ? size.width : size.height;
//   }

//   bool get isTablet => shortestSide >= 600;

//   bool get isPortrait =>
//       MediaQuery.of(this).orientation == Orientation.portrait;

//   bool get isLandscape =>
//       MediaQuery.of(this).orientation == Orientation.landscape;

//   EdgeInsets get safePadding => MediaQuery.of(this).padding;
// }

extension SkeletonizeExtension on Widget {
  Widget skeletonLoading(bool enabled) {
    return Skeletonizer(
      enabled: enabled,
      effect: PulseEffect(duration: Duration(milliseconds: 500)),
      enableSwitchAnimation: true,
      child: this,
    );
  }
}

extension DateTimeHourOffset on DateTime {
  DateTime copyWithHourOffset(int offset) {
    int baseHour = hour;

    if (baseHour < 9) {
      baseHour = 9;
    }

    return DateTime(
      year,
      month,
      day,
      baseHour + offset,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
