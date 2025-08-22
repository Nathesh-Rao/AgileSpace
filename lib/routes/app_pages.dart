import 'package:axpert_space/modules/landing/landing.dart';
import 'package:axpert_space/modules/leaves/screens/leave_details_screen.dart';
import 'package:axpert_space/modules/payroll/screens/payroll_details_page.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:axpert_space/modules/modules.dart';
import '../modules/attendance/attendance.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => WelcomeScreen(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: AppRoutes.onBoarding,
      page: () => OnboardingScreen(),
      transition: Transition.rightToLeft,
      curve: Curves.decelerate,
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: AppRoutes.permissionLocation,
      page: () => PermissionLocationScreen(),
      transition: Transition.downToUp,
      curve: Curves.decelerate,
      binding: PermissionsBindings(),
    ),
    GetPage(
      name: AppRoutes.permissionNotification,
      page: () => PermissionNotificationScreen(),
      transition: Transition.downToUp,
      curve: Curves.decelerate,
      binding: PermissionsBindings(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => AuthLoginScreen(),
      transition: Transition.rightToLeft,
      curve: Curves.decelerate,
      binding: AuthBindings(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => AuthOtpScreen(),
      transition: Transition.rightToLeft,
      curve: Curves.decelerate,
      binding: AuthBindings(),
    ),
    GetPage(
      name: AppRoutes.landing,
      page: () => LandingScreen(),
      transition: Transition.rightToLeft,
      curve: Curves.decelerate,
      binding: LandingBindings(),
    ),
    GetPage(
      name: AppRoutes.tasDetails,
      page: () => TaskDetailsScreen(),
      transition: Transition.rightToLeft,
      curve: Curves.decelerate,
    ),
    GetPage(
      name: AppRoutes.leaveDetails,
      page: () => LeaveDetailsScreen(),
      transition: Transition.rightToLeft,
      curve: Curves.decelerate,
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => AttendanceScreen(),
      transition: Transition.rightToLeft,
      curve: Curves.decelerate,
    ),
    GetPage(
      name: AppRoutes.payRollDetails,
      page: () => PayrollDetailsPage(),
      transition: Transition.rightToLeft,
      curve: Curves.decelerate,
    ),
  ];
}
