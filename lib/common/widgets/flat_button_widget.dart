import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';

class FlatButtonWidget extends StatelessWidget {
  const FlatButtonWidget({
    super.key,
    required this.label,
    this.color,
    this.bgColor,
    this.height,
    this.width,
    this.onTap,
    this.fontSize,
    this.isCompact = false,
  });
  final Color? color;
  final Color? bgColor;
  final String label;
  final Function()? onTap;
  final double? height;
  final double? width;
  final double? fontSize;
  final bool isCompact;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (isCompact ? 40.h : 50.h),
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(5.w),
            elevation: 0,
            backgroundColor: color != null
                ? color!.withAlpha(50)
                : AppColors.flatButtonColorBlue.withAlpha(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            )),
        onPressed: onTap,
        child: Text(
          label,
          style: AppStyles.textButtonStyleNormal.copyWith(
              color: color ?? AppColors.flatButtonColorBlue,
              fontSize: isCompact ? 11.5.sp : fontSize,
              fontWeight: isCompact ? FontWeight.w500 : null),
        ),
      ),
    );
  }
}
