import 'package:flutter/material.dart';
import 'package:axpert_space/core/core.dart';
import '../common.dart';

class SecondaryButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SecondaryButtonWidget({
    super.key,
    required this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.margin,
    this.labelStyle,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 55.h,
      width: width ?? double.infinity,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 25.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? AppColors.secondaryButtonBGColorWhite,
          foregroundColor: foregroundColor ?? AppColors.secondaryButtonFGColorViolet,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.secondaryButtonBorderColorGrey),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: child,
      ),
    );
  }
}
