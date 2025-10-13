// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../../common/common.dart';
import '../core.dart';

final GlobalVariableController globalVariableController = Get.find();

class Const {
  // globalVariableController.WEB_URL.value =
  //     "https://alpha.agilecloud.biz/axpert";
  // globalVariableController.ARM_URL.value = "https://alpha.agilecloud.biz/arm";
  // globalVariableController.PROJECT_NAME.value = "agilespace";

  // static const String BASE_WEB_URL = "https://alpha.agilecloud.biz/axpert";
  // static const String CONST_ARM_URL = "https://alpha.agilecloud.biz/arm";
  // static const String CONST_PROJECTNAME = "agilespace";

  static String APP_VERSION = '';
  static const String APP_RELEASE_ID = '.01';
  static const String APP_RELEASE_DATE = '08102025';
  static const String BASE_WEB_URL =
      "https://agileqa.agilecloud.biz/qaaxpert11.4base";
  static const String CONST_ARM_URL =
      "https://agileqa.agilecloud.biz/qaarm11.4base";
  static const String CONST_PROJECTNAME = "agilespaceqanew";

  static const String CLOUD_PROJECT = "axpmobileclient";
  static const String CLOUD_URL = "";
  static final String SEED_V = "1983";
  static String getSQLforClientID(String clientID) =>
      "select * from tblclientMST where clientid = '$clientID'";
  static String DUMMY_USER = "admin";
  static const String DUMMYUSER_PWD = "a5ca360e803b868680e2b6f7805fcb9e";

  static const String SCRIPT_PUNCH_INN = 'script1';
  static const String SCRIPT_PUNCH_OUT = 'script2';

  static bool isLogEnabled = false;

  // static var APP_VERSION = '0.01';

  static String getFullARMUrl(String Entrypoint) {
    print("getFullARMUrl => ${globalVariableController.ARM_URL.value}");
    if (globalVariableController.ARM_URL.value == "") {
      var data = AppStorage().retrieveValue(AppStorage.ARM_URL) ?? "";
      return data.endsWith("/") ? data + Entrypoint : data + "/" + Entrypoint;
    } else {
      return globalVariableController.ARM_URL.value.endsWith("/")
          ? globalVariableController.ARM_URL.value + Entrypoint
          : "${globalVariableController.ARM_URL.value}/$Entrypoint";
    }
  }

  static String getFullWebUrl(String Entrypoint) {
    if (globalVariableController.WEB_URL.value == "") {
      var data = AppStorage().retrieveValue(AppStorage.PROJECT_URL) ?? "";
      return data.endsWith("/") ? data + Entrypoint : data + "/" + Entrypoint;
    } else {
      // print("form const" + PROJECT_URL);
      return globalVariableController.WEB_URL.value.endsWith("/")
          ? globalVariableController.WEB_URL.value + Entrypoint
          : "${globalVariableController.WEB_URL.value}/$Entrypoint";
    }
  }

  static String getAppBody() =>
      "{\"Appname\":\"${globalVariableController.PROJECT_NAME.value}\"}";
}
