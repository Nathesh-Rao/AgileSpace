import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';

class IconLabelWidget extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String label;
  final double iconSize;
  final TextStyle? textStyle;
  final double spacing;

  const IconLabelWidget({
    super.key,
    this.icon,
    this.iconColor,
    required this.label,
    this.iconSize = 15,
    this.textStyle,
    this.spacing = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon ?? Icons.circle,
          size: iconSize.w,
          color: iconColor,
        ),
        spacing.horizontalSpace,
        Text(
          label,
          style: textStyle ??
              GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
        ),
      ],
    );
  }
}
