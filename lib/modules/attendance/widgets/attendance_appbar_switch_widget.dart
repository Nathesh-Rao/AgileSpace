import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/attendance/attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load_switch/load_switch.dart';

class AttendanceAppBarSwitchWidget extends GetView<AttendanceController> {
  const AttendanceAppBarSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 45.w,
        width: 90.w,
        child: Stack(
          children: [
            Obx(
              () => LoadSwitch(
                height: 45.w,
                width: 90.w,
                thumbSizeRatio: 0.9,
                switchDecoration: (value, _) => BoxDecoration(
                  color: !value ? Color(0xffE6F4F0) : Colors.white,
                  borderRadius: BorderRadius.circular(50.r),
                  shape: BoxShape.rectangle,
                ),
                spinColor: (value) {
                  // return !value ? AppColors.snackBarSuccessColorGreen : AppColors.snackBarErrorColorRed;
                  return Colors.white;
                },
                thumbDecoration: (value, _) => BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          globalVariableController.PROFILE_PICTURE.value)),
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: !value
                          ? AppColors.snackBarSuccessColorGreen
                          : AppColors.snackBarErrorColorRed),
                ),
                isLoading: controller.isAttendanceDetailsIsLoading.value,
                value: controller.attendanceAppbarSwitchValue.value,
                future: () async {
                  return controller.attendanceAppbarSwitchValue.value;
                },
                style: SpinStyle.material,
                onTap: controller.onAttendanceAppbarSwitch,
                onChange: (_) {},
              ),
            ),
            Visibility(
              visible: !controller.attendanceAppbarSwitchValue.value &&
                  !controller.attendanceAppbarSwitchIsLoading.value,
              child: Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Inn",
                    style: AppStyles.textButtonStyle.copyWith(
                      color: Colors.green,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
