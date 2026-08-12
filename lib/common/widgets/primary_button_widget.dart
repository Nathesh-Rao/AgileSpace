import 'package:flutter/material.dart';
import 'package:axpert_space/core/core.dart';
import '../common.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  const PrimaryButtonWidget({
    super.key,
    required this.onPressed,
    required this.label,
    this.height,
    this.width,
    this.margin,
    this.labelStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 55.h,
      width: width ?? double.infinity,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 25.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? AppColors.primaryButtonBGColorViolet,
          foregroundColor: foregroundColor ?? AppColors.primaryButtonFGColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          label,
          style: labelStyle ??
              GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
