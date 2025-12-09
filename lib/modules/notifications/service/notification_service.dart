import 'dart:convert';
import 'dart:io';

import 'package:axpert_space/common/location/location_service_manager.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/notifications/controller/notification_controller.dart';
import 'package:axpert_space/modules/notifications/model/firebase_message_model.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:platform_device_id_plus/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await GetStorage.init();

  final service = AppNotificationsService();

  await service.handleMessage(message, isBackground: true);
}

class AppNotificationsService {
  AppNotificationsService();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  bool hasPermission = true;
  String? fcmId;

  // ---------------------------------------------------------------------------

  fcmPrint(String msg) {
    debugPrint("AppNotificationsService : $msg");
  }

  Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (Platform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    hasPermission =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: ios);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    fcmId = await messaging.getToken();
    fcmPrint("FCM ID: $fcmId");

    FirebaseMessaging.onMessage.listen(_onForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpened);
    // FirebaseMessaging.onBackgroundMessage(_onBackground);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    fcmPrint("Notification module initialized");
  }

  // ---------------------------------------------------------------------------
  void _onForeground(RemoteMessage msg) {
    handleMessage(msg);
  }

  void _onOpened(RemoteMessage msg) {
    _openNotificationPage();
  }

  @pragma('vm:entry-point')
  static Future<void> _onBackground(RemoteMessage msg) async {
    // await GetStorage.init();
    AppNotificationsService().handleMessage(msg, isBackground: true);
  }

  void _onNotificationTap(NotificationResponse r) {
    _openNotificationPage();
  }

  // ---------------------------------------------------------------------------
  Future<void> handleMessage(RemoteMessage msg,
      {bool isBackground = false}) async {
    final data = msg.data;
    fcmPrint("FCM Data: ${jsonEncode(data)}");

    if (data.containsKey("type")) {
      await _handleServiceCommand(data, isBackground: isBackground);
      return;
    }

    await _handleUserNotification(data, isBackground);
  }

  // ---------------------------------------------------------------------------
  Future<void> _handleServiceCommand(Map data,
      {bool isBackground = false}) async {
    String type = data['type'].toString().toLowerCase();

    if (type.contains("location")) {
      await _handleLocationServiceCommand(data);
    } else {
      await _handleUserNotificationWithType(data, isBackground);
    }
  }

  _handleLocationServiceCommand(Map data) async {
    String type = data['type'].toString().toLowerCase();
    if (type == "sendlocation") {
      String identifier = data['identifier'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      Map outer = jsonDecode(prefs.getString("outerData") ?? "{}");
      Map inner = outer[identifier] ?? {};

      inner["interval"] = data["interval"];
      inner["lastData"] = jsonEncode(data);

      outer[identifier] = inner;
      await prefs.setString("outerData", jsonEncode(outer));

      await startLocationTracking();
      return;
    }
    if (type == "stoplocation") {
      String identifier = data['identifier'];
      stopLocationTracking(identifier);
      return;
    }
  }

  Future<void> _handleUserNotification(Map data, bool isBackground) async {
    String projectName = "";
    String userName = "";

    if (isBackground) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      projectName = prefs.getString("cached_project_name") ?? "";
      userName = prefs.getString("cached_nick_name") ?? "";
    } else {
      projectName = globalVariableController.PROJECT_NAME.value.trim();
      userName = globalVariableController.NICK_NAME.value.trim();
    }

    fcmPrint("Context: ${isBackground ? "Background" : "Foreground"}");
    fcmPrint("Project: $projectName | User: $userName");

    late String notiProjectName;
    late FirebaseMessageModel model;

    try {
      // model = FirebaseMessageModel(
      //   data["notify_title"],
      //   data["notify_body"],
      // );
      model = FirebaseMessageModel.fromJson(data);
      var det = jsonDecode(data["project_details"]);
      notiProjectName = det["projectname"].toString();
      String notifyTo = det["notify_to"].toString();

      // Logic Checks
      if (notiProjectName != projectName) return;
      if (!notifyTo.toLowerCase().contains(userName.toLowerCase())) return;
    } catch (e) {
      fcmPrint(e.toString());
      return;
    }
    bool showNotify =
        await AppStorage().retrieveValue(AppStorage.isShowNotifyEnabled) ??
            true;

    if (hasPermission && showNotify) {
      await _local.show(
        model.hashCode,
        model.title,
        model.body,
        NotificationDetails(
            android: AndroidNotificationDetails('Default', 'Default',
                icon: 'ic_notify',
                importance: Importance.max,
                priority: Priority.high,
                largeIcon: DrawableResourceAndroidBitmap('ic_launcher')
                // color: Color(0xff142071),
                )),
      );
    }

    if (isBackground) {
      await _saveBackground(data);
    } else {
      await _saveForeground(data, notiProjectName, userName);
    }

    if (!isBackground) {
      _updateControllers();
    }
  }

  Future<void> _handleUserNotificationWithType(
      Map data, bool isBackground) async {
    String projectName = "";
    String userName = "";

    if (isBackground) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      projectName = prefs.getString("cached_project_name") ?? "";
      userName = prefs.getString("cached_nick_name") ?? "";
    } else {
      projectName = globalVariableController.PROJECT_NAME.value.trim();
      userName = globalVariableController.NICK_NAME.value.trim();
    }

    fcmPrint("Context: ${isBackground ? "Background" : "Foreground"}");
    fcmPrint("Project: $projectName | User: $userName");

    late String notiProjectName;
    late FirebaseMessageModel model;

    try {
      // model = FirebaseMessageModel(
      //   data["notify_title"],
      //   data["notify_body"],
      // );
      model = FirebaseMessageModel.fromJson(data);
      var det = jsonDecode(data["project_details"]);
      notiProjectName = det["projectname"].toString();
      String notifyTo = det["notify_to"].toString();

      // Logic Checks
      if (notiProjectName != projectName) return;
      if (!notifyTo.toLowerCase().contains(userName.toLowerCase())) return;
    } catch (e) {
      fcmPrint(e.toString());
      return;
    }
    bool showNotify =
        await AppStorage().retrieveValue(AppStorage.isShowNotifyEnabled) ??
            true;

    if (hasPermission && showNotify) {
      await _local.show(
        model.hashCode,
        model.title,
        model.body,
        await getNotificationDetailsByType(data, model),
      );
    }

    if (isBackground) {
      await _saveBackground(data);
    } else {
      await _saveForeground(data, notiProjectName, userName);
    }

    if (!isBackground) {
      _updateControllers();
    }
  }

  // ---------------------------------------------------------------------------
  Future<void> _saveBackground(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    List<String> list = prefs.getStringList(AppStorage.BG_NOTIFICATIONS) ?? [];
    // list.add(jsonEncode(data));
    list.add(
        jsonEncode({...data, "timestamp": DateTime.now().toIso8601String()}));

    await prefs.setStringList(AppStorage.BG_NOTIFICATIONS, list);
  }

  // ---------------------------------------------------------------------------
  // Future<void> _saveForeground(Map data, String project, String user) async {
  //   AppStorage storage = AppStorage();

  //   Map all = storage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
  //   Map projMap = all[project] ?? {};
  //   List userList = projMap[user] ?? [];

  //   // userList.insert(0, jsonEncode(data));
  //   userList.insert(
  //       0,
  //       jsonEncode(
  //           {...data, "timestamp": DateTime(2024, 5, 1).toIso8601String()}));
  //   projMap[user] = userList;
  //   all[project] = projMap;

  //   storage.storeValue(AppStorage.NOTIFICATION_LIST, all);

  //   Map unread = storage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
  //   Map unreadProj = unread[project] ?? {};
  //   int current = int.tryParse(unreadProj[user] ?? "0") ?? 0;
  //   unreadProj[user] = "${current + 1}";
  //   unread[project] = unreadProj;

  //   storage.storeValue(AppStorage.NOTIFICATION_UNREAD, unread);
  //   try {
  //     final c = Get.find<NotificationController>();
  //     c.notifications.insert(0, FirebaseMessageModel.fromJson(data));
  //     fcmPrint("c.notifications.length ${c.notifications.length}");
  //   } catch (e) {
  //     fcmPrint(e.toString());
  //   }
  // }

  Future<void> _saveForeground(Map data, String project, String user) async {
    AppStorage storage = AppStorage();

    final savedData = {
      ...data,
      "timestamp": DateTime.now().toIso8601String(),
    };

    Map all = storage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map projMap = all[project] ?? {};
    List userList = projMap[user] ?? [];

    userList.insert(0, jsonEncode(savedData));
    projMap[user] = userList;
    all[project] = projMap;

    storage.storeValue(AppStorage.NOTIFICATION_LIST, all);

    Map unread = storage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    Map unreadProj = unread[project] ?? {};
    int current = int.tryParse(unreadProj[user] ?? "0") ?? 0;
    unreadProj[user] = "${current + 1}";
    unread[project] = unreadProj;

    storage.storeValue(AppStorage.NOTIFICATION_UNREAD, unread);

    try {
      final c = Get.find<NotificationController>();
      c.notifications.add(FirebaseMessageModel.fromJson(savedData));
      c.notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      fcmPrint(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  void _updateControllers() {
    try {
      final c = Get.find<NotificationController>();
      c.needRefreshNotification.value = true;
      c.notificationPageRefresh.value = true;
      c.showBadge.value = true;
      c.badgeCount.value++;

      fcmPrint("FCM Data: c.badgeCount.value ${c.badgeCount.value}");
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  void _openNotificationPage() {
    try {
      Get.toNamed(AppRoutes.notification);
    } catch (_) {
      Get.toNamed(AppRoutes.splash);
    }
  }

  // ---------------------------------------------------------------------------
  Future<void> callApiForMobileNotification() async {
    try {
      String imei = await PlatformDeviceId.getDeviceId ?? "0";
      AppStorage storage = AppStorage();

      var body = {
        'ARMSessionId': storage.retrieveValue(AppStorage.SESSIONID),
        'firebaseId': fcmId ?? "0",
        'ImeiNo': imei,
      };

      var url = Const.getFullARMUrl(ServerConnections.API_MOBILE_NOTIFICATION);

      var resp = await ServerConnections().postToServer(
        url: url,
        body: jsonEncode(body),
        isBearer: true,
      );

      fcmPrint("Mobile Notification API Response: $resp");
    } catch (e) {
      fcmPrint("Error in _callApiForMobileNotification: $e");
    }
  }

  static Future<void> cacheUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cached_project_name",
        globalVariableController.PROJECT_NAME.value.trim());
    await prefs.setString(
        "cached_nick_name", globalVariableController.NICK_NAME.value.trim());
  }

  Future<NotificationDetails> getNotificationDetailsByType(
      Map data, FirebaseMessageModel model) async {
    late NotificationDetails notification;
    String type = data['type'].toString().toLowerCase();
    switch (type) {
      case "default":
        notification = NotificationDetails(
            android: AndroidNotificationDetails('Default', 'Default',
                icon: 'ic_notify',
                importance: Importance.max,
                priority: Priority.high,
                largeIcon: DrawableResourceAndroidBitmap('ic_launcher')
                // color: Color(0xff142071),
                ));
        break;
      case "promotion":
        String? bigPictureUrl = data["promotion_image"];
        try {
          if (bigPictureUrl != null && bigPictureUrl.isNotEmpty) {
            final String bigPicturePath =
                await _downloadAndSaveFile(bigPictureUrl);

            var styleInfo = BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicturePath),
              largeIcon: const DrawableResourceAndroidBitmap('ic_launcher'),
              contentTitle: model.title,
              summaryText: model.body,
              hideExpandedLargeIcon: true,
            );

            notification = NotificationDetails(
                android: AndroidNotificationDetails('Default', 'Default',
                    icon: 'ic_notify',
                    importance: Importance.max,
                    priority: Priority.high,
                    largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
                    styleInformation: styleInfo
                    // color: Color(0xff142071),
                    ));
          }
        } catch (e) {
          fcmPrint(e.toString());
          notification = NotificationDetails(
              android: AndroidNotificationDetails(
            'Default', 'Default',
            icon: 'ic_notify',
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),

            // color: Color(0xff142071),
          ));
        }

      case "task":
        List<AndroidNotificationAction> actions = [];
        var taskAction = jsonDecode(data["task_details"])["task_action"];
        if (taskAction == "created") {
          actions = [
            const AndroidNotificationAction(
              'task_accept',
              'Accept',
              showsUserInterface: true,
            ),
            const AndroidNotificationAction(
              'task_reject',
              'Reject',
              showsUserInterface: true,
            ),
          ];
        } else if (taskAction == "updated") {
          actions = [
            const AndroidNotificationAction(
              'task_view_changes',
              'View Changes',
              showsUserInterface: true,
            ),
            const AndroidNotificationAction(
              'task_mark_read',
              'Mark as Read',
              showsUserInterface: false,
            ),
          ];
        }

        notification = NotificationDetails(
            android: AndroidNotificationDetails(
          'Default', 'Default',
          icon: 'ic_notify',
          importance: Importance.max,
          priority: Priority.high,
          largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
          // color: Color(0xff142071),
          actions: actions,
        ));
        break;
      default:
        notification = NotificationDetails(
            android: AndroidNotificationDetails('Default', 'Default',
                icon: 'ic_notify',
                importance: Importance.max,
                priority: Priority.high,
                largeIcon: DrawableResourceAndroidBitmap('ic_launcher')
                // color: Color(0xff142071),
                ));
        break;
    }

    return notification;
  }

  Future<String> _downloadAndSaveFile(
    String url,
  ) async {
    final Directory directory = await getApplicationDocumentsDirectory();

    Uri uri = Uri.parse(url);
    String path = uri.path;

    String extension = 'jpg';
    if (path.contains('.')) {
      extension = path.split('.').last;
    }

    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}.$extension';
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
