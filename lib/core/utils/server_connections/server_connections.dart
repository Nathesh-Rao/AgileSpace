import 'dart:convert';

import 'package:axpert_space/common/common.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/log_service/log_services.dart';
import '../../app_storage/app_storage.dart';
import '../../core.dart';
import '../internet_connections/internet_connections.dart';

class ServerConnections {
  static var client = http.Client();
  InternetConnectivity internetConnectivity = Get.find();
  static const String API_GET_USERGROUPS = "api/v1/ARMUserGroups";
  static const String API_GET_SIGNINDETAILS = "api/v1/ARMSigninDetails";
  static const String API_SIGNIN = "api/v1/Signin"; //"api/v1/ARMSignIn";
  static const String API_GET_LOGINUSER_DETAILS = "api/v1/GetLoginUserDetails";
  static const String API_VALIDATE_OTP = "api/v1/ValidateOTP";
  static const String API_RESEND_OTP = "api/v1/ResendOTP";
  static const String API_AX_START_SESSION = "api/v1/AxStartSession";

  static const String API_GET_APPSTATUS = "api/v1/ARMAppStatus";
  static const String API_ADDUSER = "api/v1/ARMAddUser";
  static const String API_OTP_VALIDATE_USER = "api/v1/ARMValidateAddUser";
  static const String API_FORGOTPASSWORD = "api/v1/ARMForgotPassword";
  static const String API_VALIDATE_FORGETPASSWORD = "api/v1/ARMValidateForgotPassword";
  static const String API_GOOGLESIGNIN_SSO = "api/v1/ARMSigninSSO";
  static const String API_CONNECTTOAXPERT = "api/v1/ARMConnectToAxpert";
  static const String API_GET_HOMEPAGE_CARDS = "api/v1/ARMGetHomePageCards";
  static const String API_GET_HOMEPAGE_CARDS_v2 = "api/v2/ARMGetHomePageCards";
  static const String API_DATASOURCE = "api/v1/ARMGetDataResponse";

  static const String API_GET_CARDS_WITH_DATA = "api/v1/GetCardsWithData";

  static const String API_MOBILE_NOTIFICATION = "api/v1/ARMMobileNotification";
  static const String API_GET_DASHBOARD_DATA = "api/v1/ARMGetCardsData";
  static const String API_CHANGE_PASSWORD = "api/v1/ARMChangePassword";

  static const String API_GET_MENU = "api/v1/ARMGetMenu";
  static const String API_GET_MENU_V2 = "api/v2/ARMGetMenu";
  static const String API_SIGNOUT = "api/v1/ARMSignOut";

  static const String API_GET_PENDING_ACTIVETASK = "api/v1/ARMGetPendingActiveTasks";
  static const String API_GET_PENDING_ACTIVETASK_COUNT = "api/v1/ARMGetPendingActiveTasksCount";
  static const String API_GET_ACTIVETASK_DETAILS = "api/v1/ARMPEGGetTaskDetails";
  static const String API_GET_FILTERED_PENDING_TASK = "api/v1/ARMGetFilteredActiveTasks";
  static const String API_GET_COMPLETED_ACTIVETASK = "api/v1/ARMGetCompletedTasks";
  static const String API_GET_COMPLETED_ACTIVETASK_COUNT = "api/v1/ARMGetCompletedTasksCount";
  static const String API_GET_FILTERED_COMPLETED_TASK = "api/v1/ARMGetFilteredCompletedTasks";
  static const String API_DO_TASK_ACTIONS = "api/v1/ARMDoTaskAction";
  static const String API_GET_ALL_ACTIVE_TASKS = "api/v1/ARMGetAllActiveTasks";
  static const String API_GET_BULK_APPROVAL_COUNT = "api/v1/ARMGetBulkApprovalCount";
  static const String API_GET_BULK_ACTIVETASKS = "api/v1/ARMGetBulkActiveTasks";
  static const String API_POST_BULK_DO_BULK_ACTION = "api/v1/ARMDoBulkAction";
  static const String API_GET_SENDTOUSERS = "api/v1/ARMGetSendToUsers";
  static const String API_GET_FILE_BY_RECORDID = "api/v1/GetFileByRecordId";
  static const String BANNER_JSON_NAME = "mainpagebanner.json";

  AppStorage appStorage = AppStorage();

  ServerConnections() {
    client = http.Client();
  }

  var _baseBody = "";

  String _baseUrl = "http://demo.agile-labs.com/axmclientidscripts/asbmenurest.dll/datasnap/rest/Tasbmenurest/getchoices";

  postToServer(
      {String url = '',
      var header = '',
      String body = '',
      String ClientID = '',
      bool isBearer = false,
      var show_errorSnackbar = true}) async {
    var API_NAME = url.substring(url.lastIndexOf("/") + 1, url.length);
    if (await internetConnectivity.connectionStatus) {
      try {
        if (ClientID != '') _baseBody = _generateBody(ClientID.toLowerCase());
        if (url == '') url = _baseUrl;
        if (header == '') header = {"Content-Type": "application/json"};
        if (body == '') body = _baseBody;
        if (isBearer) {
          header = {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + appStorage.retrieveValue(AppStorage.TOKEN).toString() ?? "",
          };
        }
        print("API_POST_URL: $url");
        // print("Post header: $header");
        print("API_POST_BODY:" + body);
        var response = await client.post(Uri.parse(url), headers: header, body: body);

        if (response.statusCode == 200) {
          LogService.writeLog(
              message:
                  "[^] [POST] URL:$url\nAPI_NAME: $API_NAME\nBody: $body\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
          return response.body;
        }

        if (response.statusCode == 404) {
          print("API_ERROR: $API_NAME: ${response.body}");
          AppSnackBar.showError("Error! ${response.statusCode.toString()}", "Something went wrong");
        } else {
          if (response.statusCode == 400) {
            LogService.writeLog(
                message:
                    "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nBody: $body\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
            return response.body;
          } else {
            print("API_ERROR: $API_NAME: ${response.body}");
            LogService.writeLog(
                message:
                    "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nBody: $body\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
            var msg = response.body.toString();
            if (response.body.toString().contains("message")) {
              try {
                var jsonResp = jsonDecode(response.body);
                // print(jsonResp);
                msg = jsonResp['result']['message'].toString();
              } catch (e) {
                print(e);
              }
            }
            AppSnackBar.showError("Error! ${response.statusCode.toString()}", API_NAME + ": " + msg);
          }
        }
      } catch (e) {
        print("API_ERROR: $API_NAME: ${e.toString()}");
        AppSnackBar.showError("Error!", e.toString());
      }
    }

    return "";
  }

  // parseData(http.Response response) async {
  //   try {
  //     if (response.statusCode == 200) return response.body;
  //     if (response.statusCode == 404) {
  //       Get.snackbar("Error " + response.statusCode.toString(), "Invalid Url",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white);
  //     } else {
  //       Get.snackbar(
  //           "Error " + response.statusCode.toString(), "Internal server error",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error ", e.toString(),
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.redAccent,
  //         colorText: Colors.white);
  //   }
  // }

  getFromServer({String url = '', var header = '', var show_errorSnackbar = true}) async {
    var API_NAME = url.substring(url.lastIndexOf("/") + 1, url.length);
    try {
      if (url == '') url = _baseUrl;

      if (header == '') header = {"Content-Type": "application/json"};
      print("Get Url: $url");
      var response = await client.get(Uri.parse(url), headers: header);

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        LogService.writeLog(
            message:
                "[^] [POST] URL:$url\nAPI_NAME: $API_NAME\nBody: $decodedBody\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
        return decodedBody;
        // return response.body;
      }

      if (response.statusCode == 404) {
        LogService.writeLog(
            message:
                "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
        if (API_NAME.toString().toLowerCase() == "ARMAppStatus".toLowerCase()) {
          AppSnackBar.showError("Error!", "Invalid ARM URL");
        } else {
          AppSnackBar.showError("Error! ${response.statusCode.toString()}", "Invalid ARM URL");
        }
      } else {
        LogService.writeLog(
            message:
                "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nStatusCode: ${response.statusCode}\nResponse: ${response.body}");
        AppSnackBar.showError("Error! ${response.statusCode.toString()}", "Internal server error");
      }
    } catch (e) {
      // LogService.writeLog(message: "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nError: ${e.toString()}");
      if (e.toString().contains("ClientException with SocketException")) {
        await Future.delayed(Duration(seconds: 4));

        try {
          var reResponse = await client.get(Uri.parse(url), headers: header);

          if (reResponse.statusCode == 200) {
            var decodedBody = utf8.decode(reResponse.bodyBytes);
            return decodedBody;
            // return response.body;
          }

          if (reResponse.statusCode == 404) {
            LogService.writeLog(
                message:
                    "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nStatusCode: ${reResponse.statusCode}\nResponse: ${reResponse.body}");
            if (API_NAME.toString().toLowerCase() == "ARMAppStatus".toLowerCase()) {
              AppSnackBar.showError("Error!", "Invalid ARM URL");
            } else {
              AppSnackBar.showError("Error! ${reResponse.statusCode.toString()}", "Invalid ARM URL");
            }
          } else {
            // LogService.writeLog(message: "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nError: ${e.toString()}");
            LogService.writeLog(
                message:
                    "[ERROR] API_ERROR\nURL:$url\nAPI_NAME: $API_NAME\nStatusCode: ${reResponse.statusCode}\nResponse: ${reResponse.body}");
            AppSnackBar.showError("Error! ${reResponse.statusCode.toString()}", "Internal server error");
          }
        } catch (err) {
          AppSnackBar.showError("Error! ", err.toString());
        }
      }
      AppSnackBar.showError("Error! ", e.toString());

      // LogService.writeLog(message: "getFromServer(): ${e.toString()}");

      // Get.snackbar("Error ", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
    // LoadingScreen.dismiss();
  }

  _generateBody(String ClientId) {
    return "{\"_parameters\":[{\"getchoices\":"
        "{\"axpapp\":\"${Const.CLOUD_PROJECT}\","
        "\"username\":\"${Const.DUMMY_USER}\","
        "\"password\":\"${Const.DUMMYUSER_PWD}\","
        "\"seed\":\"${Const.SEED_V}\","
        "\"trace\":\"true\","
        "\"sql\":\"${Const.getSQLforClientID(ClientId)}\","
        "\"direct\":\"false\","
        "\"params\":\"\"}}]}";
  }

  Future<void> fetchDataWithRetry() async {
    try {
      final response = await http.get(Uri.parse("https://your.api.com"));
      // handle response
    } catch (e) {
      // Retry once after short delay
      await Future.delayed(Duration(seconds: 2));
      try {
        final retryResponse = await http.get(Uri.parse("https://your.api.com"));
        // handle retry response
      } catch (retryError) {
        print("Final failure: $retryError");
      }
    }
  }
}
