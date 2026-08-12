import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';

class SettingsTabHeaderWidget extends StatelessWidget {
  const SettingsTabHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          image: DecorationImage(
              image: AssetImage("assets/images/common/profile_bg.png"),
              fit: BoxFit.cover)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34.h,
            backgroundColor: Colors.white,
            child: Obx(
              () => CircleAvatar(
                radius: 30.h,
                backgroundImage:
                    AssetImage(globalVariableController.PROFILE_PICTURE.value),
              ),
            ),
          ),
          20.horizontalSpace,
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Flexible(
                    child: AutoSizeText(
                      "Mr ${globalVariableController.NICK_NAME.value}",
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      // softWrap: false,
                    ),
                  ),
                ),
                Text(
                  globalVariableController.USER_EMAIL.value,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
