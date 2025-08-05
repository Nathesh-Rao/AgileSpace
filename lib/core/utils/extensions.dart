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
