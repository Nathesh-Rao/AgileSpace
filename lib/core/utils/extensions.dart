import 'package:flutter/material.dart';

import '../../common/common.dart';

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
