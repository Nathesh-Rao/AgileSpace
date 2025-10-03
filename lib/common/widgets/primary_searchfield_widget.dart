import 'package:axpert_space/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/core.dart';

class PrimarySearchFieldWidget extends StatelessWidget {
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onSuffixTap;
  final String? placeholder;
  final TextEditingController? controller;
  const PrimarySearchFieldWidget(
      {super.key,
      this.onChanged,
      this.controller,
      this.onSubmitted,
      this.placeholder,
      this.onSuffixTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 15.w),
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.primarySearchFieldBGColorGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CupertinoSearchTextField(
          controller: controller,
          placeholder: placeholder,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          prefixInsets: EdgeInsets.only(left: 10.w),
          suffixInsets: EdgeInsets.only(right: 10.w),
          itemColor: Colors.grey.shade800,
          placeholderStyle: AppStyles.searchFieldTextStyle
              .copyWith(color: Colors.grey.shade400),
          style: AppStyles.searchFieldTextStyle,
          decoration: BoxDecoration(
            color: AppColors.primarySearchFieldBGColorGrey,
            borderRadius: BorderRadius.circular(10.r),
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onSuffixTap: onSuffixTap,
        ),
      ),
    );
  }
}
