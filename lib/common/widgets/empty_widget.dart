import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.width, this.label});
  final double? width;
  final String? label;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/common/no-data.png",
          width: width ?? 1.sw / 3,
        ),
        10.verticalSpace,
        Text(
          label ?? "No Data Found",
          style: GoogleFonts.poppins(
            color: AppColors.primaryTitleTextColorBlueGrey,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
