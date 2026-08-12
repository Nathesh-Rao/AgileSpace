import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:axpert_space/common/common.dart';

import '../../core/core.dart';

class AuthTextFieldWidget extends StatelessWidget {
  const AuthTextFieldWidget({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.controller,
    this.suffixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
    this.focusNode,
    this.errorText = '',
  });
  final String label;
  final Widget? prefixIcon;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool obscureText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            25.horizontalSpace,
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            10.horizontalSpace,
            errorText.isEmpty
                ? SizedBox.shrink()
                : ShakeX(
                    duration: Duration(milliseconds: 500),
                    child: ChipCardWidget(borderRadius: 2, label: "*$errorText", color: AppColors.chipCardWidgetColorRed)),
            Spacer(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ShakeX(
            duration: Duration(milliseconds: 500),
            key: ValueKey(errorText),
            animate: errorText.isNotEmpty,
            child: TextFormField(
              readOnly: readOnly,
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      errorText.isNotEmpty
                          ? Icon(
                              Clarity.error_line,
                              color: AppColors.chipCardWidgetColorRed,
                              size: 20.w,
                            )
                          : prefixIcon ??
                              Icon(
                                Bootstrap.app,
                                color: AppColors.primaryTitleTextColorBlueGrey,
                                size: 20.w,
                              ),
                      5.horizontalSpace,
                      Text(
                        '|',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primaryTitleTextColorBlueGrey),
                      )
                    ],
                  ),
                ),
                suffixIcon: suffixIcon,
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40.w,
                  minHeight: 24.h,
                ),
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 12.sp,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5.h,
                    color: errorText.isEmpty ? AppColors.primarySubTitleTextColorBlueGreyLight : AppColors.chipCardWidgetColorRed,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5.h,
                    color: errorText.isEmpty ? AppColors.primaryTitleTextColorBlueGrey : AppColors.chipCardWidgetColorRed,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5.h,
                    color: errorText.isEmpty ? Colors.black : AppColors.chipCardWidgetColorRed,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1.5.h),
                ),
              ),
              validator: validator,
            ),
          ),
        ),
      ],
    );
  }
}
