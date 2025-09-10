import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile(
      {super.key, required this.value, this.onChanged, this.label, this.icon});
  final bool value;
  final Function(bool)? onChanged;
  final String? label;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Color(0xffEDEEF3),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          icon ?? Icon(Icons.circle),
          15.horizontalSpace,
          Text(
            label ?? "title",
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Switch(
            value: value,
            activeTrackColor: Color(0xff424758),
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}
