import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile(
      {super.key,
      this.label,
      this.icon,
      this.trailingIcon,
      this.color,
      this.onTap});
  final String? label;
  final Widget? icon;
  final Widget? trailingIcon;
  final Color? color;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 45.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          // color: Color(0xffEDEEF3),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? Icon(Icons.circle),
            15.horizontalSpace,
            Text(
              label ?? "title",
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Spacer(),
            trailingIcon ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
