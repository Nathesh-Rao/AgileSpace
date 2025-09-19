import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';

class ChipCardWidget extends StatelessWidget {
  const ChipCardWidget({
    super.key,
    required this.label,
    this.pVertical,
    this.pHorizontal,
    this.fontSize,
    this.borderRadius,
    required this.color,
    this.onMaxSize = false,
  });
  final double? pVertical;
  final double? pHorizontal;
  final String label;
  final double? fontSize;
  final Color color;
  final bool onMaxSize;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: onMaxSize ? pVertical ?? 7.h : pVertical ?? 4.h,
          horizontal: onMaxSize ? pHorizontal ?? 12.w : pHorizontal ?? 10.w),
      decoration: BoxDecoration(
          color: label.isEmpty ? null : color.withAlpha(25),
          borderRadius: BorderRadius.circular(borderRadius ?? 50.r)),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            fontSize: onMaxSize ? fontSize ?? 12.sp : fontSize ?? 6.sp,
            fontWeight: FontWeight.w500,
            color: color),
      ),
    );
  }
}
