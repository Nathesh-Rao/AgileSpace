import 'package:get_storage/get_storage.dart';

class AppStorage {
  static const String PROJECT_NAME = "ProjectName";
  static const String PROJECT_URL = "ProjectUrl";
  static const String ARM_URL = "ArmUrl";
  static const String TOKEN = "Token";
  static const String SESSIONID = "SessionID";
  static const String USERID = "userID";
  static const String USER_PASSWORD = "userPass";
  static const String USER_NAME = "UserName";
  static const String NICK_NAME = "NickName";
  static const String USER_GROUP = "UserGroup";
  static const String USER_CHANGE_PASSWORD = "ChangePassword";
  static const String LAST_LOGIN_DATA = "LastLoginDataMap";
  static const String IS_FIRST_TIME = "IsFirstTime";
  // static const String NOTIFICATION_LIST = "NotificationList";
  // static const String NOTIFICATION_LIST = "NewNotificationList";
  // static const String NOTIFICATION_UNREAD = "NewNotificationUnReadNo";
  static const String CAN_AUTHENTICATE = "CanAuthenticate";
  // notifications
  static const String WILL_AUTHENTICATE_FOR_USER = "WillAuthenticateForUser";
  static const String NOTIFICATION_LIST = "notification_list";
  static const String NOTIFICATION_UNREAD = "notification_unread";

  // Add this if missing
  static const String BG_NOTIFICATIONS = "bg_notifications_buffer";
  static const String isShowNotifyEnabled = "isShowNotifyEnabled";
  static const String isLogEnabled = "isLogEnabled";
  static const String DEMO_IS_FIRST_INSTALL = "demoIsFirstInstall";
  late final box;

  AppStorage() {
    box = GetStorage();
  }
  storeValue(String key, var value) {
    box.write(key, value);
  }

  dynamic retrieveValue(String key) {
    return box.read(key);
  }

  remove(String key) {
    box.remove(key);
  }
}
