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
  final service = AppNotificationsService();
  await service.handleMessage(message, isBackground: true);
}

class AppNotificationsService {
  AppNotificationsService();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  bool hasPermission = true;
  static String? fcmId;
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';

  // ---------------------------------------------------------------------------

  void fcmPrint(String msg) {
    debugPrint("AppNotificationsService : $msg");
  }

  // ---------------------------------------------------------------------------

  List<DarwinNotificationCategory> _iosCategories() {
    return [
      DarwinNotificationCategory(
        'TASK_CREATED',
        actions: [
          DarwinNotificationAction.plain(
            'task_accept',
            'Accept',
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            'task_reject',
            'Reject',
            options: {DarwinNotificationActionOption.foreground},
          ),
        ],
      ),
      DarwinNotificationCategory(
        'TASK_UPDATED',
        actions: [
          DarwinNotificationAction.plain(
            'task_view_changes',
            'View Changes',
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            'task_mark_read',
            'Mark as Read',
          ),
        ],
      ),
      DarwinNotificationCategory(
        'LEAVE_REQUESTED',
        actions: [
          DarwinNotificationAction.plain(
            'leave_accept',
            'Accept',
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            'leave_reject',
            'Reject',
            options: {DarwinNotificationActionOption.foreground},
          ),
        ],
      ),
      DarwinNotificationCategory(
        'LEAVE_FINAL',
        actions: [
          DarwinNotificationAction.plain(
            'leave_view_changes',
            'View Changes',
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            'leave_mark_read',
            'Mark as Read',
          ),
        ],
      ),
    ];
  }

  // ---------------------------------------------------------------------------

  Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (Platform.isAndroid) {
      await _createAndroidChannel();
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
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = DarwinInitializationSettings(
      notificationCategories: _iosCategories(),
    );
    final initSettings = InitializationSettings(android: android, iOS: ios);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    fcmId = await messaging.getToken() ?? '';
    fcmPrint("FCM ID: $fcmId");

    FirebaseMessaging.onMessage.listen(_onForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpened);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    fcmPrint("Notification module initialized");
  }

  // ---------------------------------------------------------------------------

  Future<void> _createAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: 'Notifications for tasks and alerts',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
    fcmPrint("Android channel created: $channelId");
  }

  // ---------------------------------------------------------------------------

  void _onForeground(RemoteMessage msg) {
    handleMessage(msg);
  }

  // ---------------------------------------------------------------------------

  void _onOpened(RemoteMessage msg) {
    _openNotificationPage();
  }

  // ---------------------------------------------------------------------------

  @pragma('vm:entry-point')
  static Future<void> _onBackground(RemoteMessage msg) async {
    AppNotificationsService().handleMessage(msg, isBackground: true);
  }

  // ---------------------------------------------------------------------------

  void _onNotificationTap(NotificationResponse response) {
    final actionId = response.actionId;

    switch (actionId) {
      case 'task_accept':
        break;
      case 'task_reject':
        break;
      case 'leave_accept':
        break;
      case 'leave_reject':
        break;
      default:
        _openNotificationPage();
    }
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

  // ---------------------------------------------------------------------------

  Future<void> _handleLocationServiceCommand(Map data) async {
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

  // ---------------------------------------------------------------------------

  Future<void> _handleUserNotification(Map data, bool isBackground) async {
    String projectName = "";
    String userName = "";
    bool showNotify = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    if (isBackground) {
      projectName = prefs.getString("cached_project_name") ?? "";
      userName = prefs.getString("cached_user_name") ?? "";
      showNotify = prefs.getBool(AppStorage.isShowNotifyEnabled) ?? true;
    } else {
      projectName = prefs.getString("cached_project_name") ?? "";
      userName = prefs.getString("cached_user_name") ?? "";
      showNotify =
          await AppStorage().retrieveValue(AppStorage.isShowNotifyEnabled) ??
              true;
    }

    fcmPrint("Context: ${isBackground ? "Background" : "Foreground"}");

    late String notiProjectName;
    late FirebaseMessageModel model;

    try {
      model = FirebaseMessageModel.fromJson(data);
      var det = jsonDecode(data["project_details"]);
      notiProjectName = det["projectname"].toString();
      String notifyTo = det["notify_to"].toString();

      if (notiProjectName != projectName) return;
      if (!notifyTo.toLowerCase().contains(userName.toLowerCase())) return;
    } catch (e) {
      fcmPrint("Error parsing notification logic: $e");
      return;
    }

    if (hasPermission && showNotify) {
      try {
        await _local.show(
          model.hashCode,
          model.title,
          model.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channelId,
              channelName,
              icon: 'ic_notify',
              importance: Importance.max,
              priority: Priority.high,
              largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
            ),
          ),
        );
      } catch (e) {
        fcmPrint("Error showing local notification: $e");
      }
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

  Future<void> _handleUserNotificationWithType(
      Map data, bool isBackground) async {
    String projectName = "";
    String userName = "";
    bool showNotify = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    if (isBackground) {
      projectName = prefs.getString("cached_project_name") ?? "";
      userName = prefs.getString("cached_user_name") ?? "";
      showNotify = prefs.getBool(AppStorage.isShowNotifyEnabled) ?? true;
    } else {
      projectName = prefs.getString("cached_project_name") ?? "";
      userName = prefs.getString("cached_user_name") ?? "";
      showNotify =
          await AppStorage().retrieveValue(AppStorage.isShowNotifyEnabled) ??
              true;
    }

    fcmPrint("Context: ${isBackground ? "Background" : "Foreground"}");

    late String notiProjectName;
    late FirebaseMessageModel model;

    try {
      model = FirebaseMessageModel.fromJson(data);
      var det = jsonDecode(data["project_details"]);
      notiProjectName = det["projectname"].toString();
      String notifyTo = det["notify_to"].toString();

      if (notiProjectName != projectName) return;
      if (!notifyTo.toLowerCase().contains(userName.toLowerCase())) return;
    } catch (e) {
      fcmPrint(e.toString());
      return;
    }

    if (hasPermission && showNotify) {
      try {
        await _local.show(
          model.hashCode,
          model.title,
          model.body,
          await getNotificationDetailsByType(data, model),
        );
      } catch (e) {
        fcmPrint("Error showing notification: $e");
      }
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      List<String> list =
          prefs.getStringList(AppStorage.BG_NOTIFICATIONS) ?? [];

      final savedData = {
        ...data,
        "timestamp": DateTime.now().toIso8601String(),
        "is_opened": false
      };

      list.add(jsonEncode(savedData));

      await prefs.setStringList(AppStorage.BG_NOTIFICATIONS, list);
      fcmPrint("Saved background notification. Count: ${list.length}");
    } catch (e) {
      fcmPrint("Error saving background data: $e");
    }
  }

  // ---------------------------------------------------------------------------

  Future<void> _saveForeground(Map data, String project, String user) async {
    AppStorage storage = AppStorage();
    String projectKey = project.trim();
    String userKey = user.trim().toLowerCase();

    final savedData = {
      ...data,
      "timestamp": DateTime.now().toIso8601String(),
      "is_opened": false,
    };

    Map all = storage.retrieveValue(AppStorage.NOTIFICATION_LIST) ?? {};
    Map projMap = all[projectKey] ?? {};
    List userList = projMap[userKey] ?? [];

    userList.insert(0, jsonEncode(savedData));
    projMap[userKey] = userList;
    all[projectKey] = projMap;

    storage.storeValue(AppStorage.NOTIFICATION_LIST, all);

    Map unread = storage.retrieveValue(AppStorage.NOTIFICATION_UNREAD) ?? {};
    Map unreadProj = unread[projectKey] ?? {};
    int current = int.tryParse(unreadProj[userKey] ?? "0") ?? 0;
    unreadProj[userKey] = "${current + 1}";
    unread[projectKey] = unreadProj;

    storage.storeValue(AppStorage.NOTIFICATION_UNREAD, unread);

    try {
      final c = Get.find<NotificationController>();
      c.notifications.add(FirebaseMessageModel.fromJson(savedData));
      c.notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      c.setBadgeCount();
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
      c.setBadgeCount();
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

  // ---------------------------------------------------------------------------

  static Future<void> cacheUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cached_project_name",
        globalVariableController.PROJECT_NAME.value.trim());
    await prefs.setString(
        "cached_user_name", globalVariableController.USER_NAME.value.trim());

    bool isEnabled =
        await AppStorage().retrieveValue(AppStorage.isShowNotifyEnabled) ??
            true;
    await prefs.setBool(AppStorage.isShowNotifyEnabled, isEnabled);
  }

  // ---------------------------------------------------------------------------

  Future<NotificationDetails> getNotificationDetailsByType(
      Map data, FirebaseMessageModel model) async {
    late NotificationDetails notification;
    String type = data['type'].toString().toLowerCase();

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      icon: 'ic_notify',
      importance: Importance.max,
      priority: Priority.high,
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );

    switch (type) {
      case "default":
        notification = NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );
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
                android: AndroidNotificationDetails(
                  channelId,
                  channelName,
                  icon: 'ic_notify',
                  importance: Importance.max,
                  priority: Priority.high,
                  largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
                  styleInformation: styleInfo,
                ),
                iOS: DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                  attachments: [
                    DarwinNotificationAttachment(bigPicturePath),
                  ],
                ));
          } else {
            throw Exception("No image");
          }
        } catch (e) {
          notification = NotificationDetails(
            android: androidDetails,
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          );
        }
        break;

      case "task":
        List<AndroidNotificationAction> actions = [];
        String categoryId = '';
        var taskAction = jsonDecode(data["task_details"])["task_action"];

        if (taskAction == "created") {
          categoryId = 'TASK_CREATED';
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
          categoryId = 'TASK_UPDATED';
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
            channelId,
            channelName,
            icon: 'ic_notify',
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
            actions: actions,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            categoryIdentifier: categoryId,
          ),
        );
        break;
      case "leave":
        List<AndroidNotificationAction> actions = [];
        String categoryId = '';
        var leaveAction = jsonDecode(data["leave_details"])["leave_action"];

        if (leaveAction == "requested") {
          categoryId = 'LEAVE_REQUESTED';
          actions = [
            const AndroidNotificationAction(
              'leave_accept',
              'Accept',
              showsUserInterface: true,
            ),
            const AndroidNotificationAction(
              'leave_reject',
              'Reject',
              showsUserInterface: true,
            ),
          ];
        } else {
          categoryId = 'LEAVE_FINAL';
          actions = [
            const AndroidNotificationAction(
              'leave_view_changes',
              'View Changes',
              showsUserInterface: true,
            ),
            const AndroidNotificationAction(
              'leave_mark_read',
              'Mark as Read',
              showsUserInterface: false,
            ),
          ];
        }

        notification = NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            icon: 'ic_notify',
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
            actions: actions,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            categoryIdentifier: categoryId,
          ),
        );
        break;
      default:
        notification = NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );
        break;
    }

    return notification;
  }

  // ---------------------------------------------------------------------------

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
