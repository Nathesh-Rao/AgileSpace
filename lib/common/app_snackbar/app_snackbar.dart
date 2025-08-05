import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void showInfo(String title, String message, {Function()? onTap}) {
    _showCustomSnackBar(
      title,
      message,
      icon: Icons.info_outline,
      shadowColor: Colors.grey,
      iconBGColor: AppColors.snackBarInfoColorGrey,
      onTap: onTap,
    );
  }

  static void showNotification(String title, String message, {Function()? onTap}) {
    _showCustomSnackBar(
      title,
      message,
      icon: Icons.notifications_none,
      shadowColor: Colors.blue,
      iconBGColor: AppColors.snackBarNotificationColorBlue,
      onTap: onTap,
    );
  }

  static void showSuccess(String title, String message, {Function()? onTap}) {
    _showCustomSnackBar(
      title,
      message,
      icon: Icons.check_circle_outline,
      shadowColor: Colors.green,
      iconBGColor: AppColors.snackBarSuccessColorGreen,
      onTap: onTap,
    );
  }

  static void showWarning(String title, String message, {Function()? onTap}) {
    _showCustomSnackBar(
      title,
      message,
      icon: Icons.warning_amber_rounded,
      shadowColor: Colors.orange,
      iconBGColor: AppColors.snackBarWarningColorYellow,
      onTap: onTap,
    );
  }

  static void showError(String title, String message, {Function()? onTap}) {
    _showCustomSnackBar(
      title,
      message,
      icon: Icons.error_outline,
      shadowColor: Colors.red,
      iconBGColor: AppColors.snackBarErrorColorRed,
      onTap: onTap,
    );
  }

  static void _showCustomSnackBar(
    String title,
    String message, {
    required IconData icon,
    required Color shadowColor,
    required Color iconBGColor,
    required Function()? onTap,
  }) {
    Get.rawSnackbar(
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(12.w),
      borderRadius: 12.r,
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      messageText: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              // color: backgroundColor,
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.3), // Choose glow color
                  blurRadius: 12, // Softer spread
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ]),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: iconBGColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(icon, color: Colors.white, size: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryActionColorDarkBlue,
                          fontSize: 15,
                        )),
                    const SizedBox(height: 2),
                    Text(message,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryTitleTextColorBlueGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.closeAllSnackbars(),
                child: Icon(Icons.close, color: iconBGColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
