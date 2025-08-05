import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';

class FlatButtonWidget extends StatelessWidget {
  const FlatButtonWidget({super.key, required this.label, this.color, this.height, this.width, this.onTap});
  final Color? color;
  final String label;
  final Function()? onTap;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50.h,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color != null ? color!.withAlpha(50) : Color(0xff2A79E4).withAlpha(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            )),
        onPressed: () {},
        child: Text(
          label,
          style: AppStyles.textButtonStyleNormal.copyWith(
            color: color ?? AppColors.flatButtonColorBlue,
          ),
        ),
      ),
    );
  }
}
