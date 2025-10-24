import 'package:axpert_space/common/common.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';

class PrimaryDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final Color? borderColor;
  const PrimaryDropdownField({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide(
        color: borderColor ?? Colors.blueAccent,
        width: 1,
      ),
    );

    return DropdownButtonFormField2<String>(
      isExpanded: true,
      // ✅ Avoid crash: only assign value if it's inside items
      value: items.contains(value) ? value : null,
      style: GoogleFonts.poppins(
        fontSize: 12.sp,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        constraints: BoxConstraints(maxHeight: 40.h),
        filled: true,
        fillColor: Colors.white,
        border: borderStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide:
              BorderSide(color: borderColor ?? Colors.deepPurple, width: 1),
        ),
        contentPadding: EdgeInsets.only(right: 12.w),
      ),
      dropdownStyleData: DropdownStyleData(
        scrollbarTheme: ScrollbarThemeData(
          radius: Radius.circular(50.r),
          crossAxisMargin: 5,
          mainAxisMargin: 5,
          thumbColor: WidgetStatePropertyAll(borderColor ?? Colors.deepPurple),
        ),
        offset: const Offset(0, -10),
        maxHeight: 300.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? AppColors.chipCardWidgetColorViolet,
            width: 1,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
      ),
      items: items
          .map((p) => DropdownMenuItem(
                value: p,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Text(p),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
