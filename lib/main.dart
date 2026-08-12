import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:axpert_space/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:axpert_space/routes/app_pages.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'core/core.dart';
import 'modules/notifications/controller/firebase_message_handler.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails('Default', 'Default',
        icon: "@mipmap/ic_launcher",
        channelDescription: 'Default Notification',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'));
var hasNotificationPermission = true;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LogService.writeOnConsole(message: "Main method started.......");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initialize();
  FirebaseMessaging.onMessage.listen(onMessageListener);
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessageListner);
  FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenAppListener);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBindings(),
          initialRoute: AppRoutes.splash,
          defaultTransition: Transition.noTransition,
          getPages: AppPages.pages,
          title: const String.fromEnvironment('APP_NAME',
              defaultValue: 'AxpertSpace'),
          theme: AppTheme.lightTheme,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
