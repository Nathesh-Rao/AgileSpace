import 'dart:async';
import 'dart:convert';

import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:axpert_space/common/widgets/flat_button_widget.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_device_id_plus/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zo_animated_border/zo_animated_border.dart';
import '../../../core/core.dart';
import '../../../core/utils/server_connections/server_connections.dart';
import '../auth.dart';

class AuthController extends GetxController {
  //Login =============>
  GlobalVariableController globalVariableController = Get.find();
  var loginHeaderImage = "assets/images/auth/login_header.png";
  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  var isLoginLoading = false.obs;
  var rememberMe = false.obs;
  var googleSignInVisible = false.obs;
  var ddSelectedValue = "power".obs;
  var userTypeList = [].obs;
  var showPassword = true.obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  final passwordFocus = FocusNode();
  var errUserName = ''.obs;
  var errPassword = ''.obs;
  var fcmId;
  var willBio_userAuthenticate = false.obs;
  var isBiometricAvailable = false.obs;
  var currentProjectName = ''.obs;
  var isUserDataLoading = false.obs;
  var otpChars = '4'.obs;
  var otpExpiryTime = '2'.obs;
  var timeLeft = '00:00'.obs;
  var isTimerActive = false.obs;
  Timer? otpTimer;
  var authType = AuthType.none.obs;
  var otpMsg = ''.obs;
  var otpLoginKey = ''.obs;
  var otpErrorText = ''.obs;
  bool isDuplicate_session = false;
  bool isAxpertConnectEstablished = false;

  // final rememberMe = false.obs;
  //-------------------------------------------------------------------------------
  final _secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    loadRememberedUser();
  }

  Future<void> loadRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedUsername = prefs.getString('username');
    final isRemembered = prefs.getBool('rememberMe') ?? false;

    if (isRemembered && rememberedUsername != null) {
      userNameController.text = rememberedUsername;
      rememberMe.value = true;

      final rememberedPassword =
          await _secureStorage.read(key: rememberedUsername) ?? '';
      userPasswordController.text = rememberedPassword;
    }
  }

  Future<void> handleRememberMe(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe.value) {
      await prefs.setString('username', username);
      await prefs.setBool('rememberMe', true);
      await _secureStorage.write(key: username, value: password);
    } else {
      await prefs.remove('username');
      await prefs.setBool('rememberMe', false);
      await _secureStorage.delete(key: username);
    }
  }

  Future<void> onUsernameValidated(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedUsername = prefs.getString('username');

    if (rememberedUsername == username) {
      final savedPassword = await _secureStorage.read(key: username);
      if (savedPassword != null) {
        userPasswordController.text = savedPassword;
      }
    } else {
      userPasswordController.text = '';
    }
  }

  validate() {
    if (userNameController.text.trim().isEmpty) {
      errUserName.value = "Invalid username";
    }
  }

  // onLoginContinueButtonClick() async {
  //   isLoginLoading.value = true;
  //   await Future.delayed(Duration(seconds: 3));
  //   isLoginLoading.value = false;
  //   if (isPWD_auth.value) {
  //     AppSnackBar.showSuccess("OTP Sent", "We've sent an OTP to your registered number.");
  //     isPWD_auth.toggle();
  //     Get.toNamed(AppRoutes.otp);
  //   } else {
  //     isPWD_auth.toggle();
  //     AppSnackBar.showSuccess("Password required", "Enter your password to login");
  //   }
  // }

//OTP =============>

  var otpHeaderImage = "assets/images/auth/otp_header.png";

  var isOtpLoading = false.obs;
  var isPWD_auth = false.obs;
  var isOTP_auth = false.obs;
  TextEditingController otpFieldController = TextEditingController();

  onOtpLoginButtonClick() {
    print("onOtpLoginButtonClick()");
    if (validateOTPField()) {
      callVerifyOTP();
    }
  }

  onLoad() async {
    currentProjectName.value =
        await appStorage.retrieveValue(AppStorage.PROJECT_NAME) ?? '';
  }

  startLoginProcess() async {
    if (!validateUserName()) return;

    showPassword.value = true;
    isLoginLoading.value = true;
    authType.value = await getLoginUserDetailsAndAuthType();

    if (authType.value == AuthType.otpOnly) {
      await callSignInAPI();
    }

    if (isPWD_auth.value) {
      FocusScope.of(Get.context!).requestFocus(passwordFocus);
    }
    isLoginLoading.value = false;

    switch (authType.value) {
      case AuthType.both:
        print("✅ Both Password and OTP authentication are required.");
        break;
      case AuthType.passwordOnly:
        print("🔐 Only Password authentication is required.");
        break;
      case AuthType.otpOnly:
        print("📲 Only OTP authentication is required.");
        break;
      case AuthType.none:
        print("❌ No authentication required.");
        break;
    }
  }

  getLoginUserDetailsAndAuthType() async {
    isUserDataLoading.value = true;
    var url = Const.getFullARMUrl(ServerConnections.API_GET_LOGINUSER_DETAILS);
    var body = {
      "appname": globalVariableController.PROJECT_NAME.value,
      "UserName": userNameController.text.toString().trim(),
    };

    var response =
        await serverConnections.postToServer(url: url, body: jsonEncode(body));
    isUserDataLoading.value = false;
    if (response != "") {
      var json = jsonDecode(response);
      if (json["result"]["success"].toString().toLowerCase() == "true") {
        FocusManager.instance.primaryFocus?.unfocus();
        final authUserdetails = AuthUserDetailsModel.fromJson(json["result"]);
        isPWD_auth.value = authUserdetails.pwdauth!;
        if (authUserdetails.otpauth!) {
          isOTP_auth.value = authUserdetails.otpauth!;
          otpChars.value = authUserdetails.otpsettings!.otpchars!;
          otpExpiryTime.value = authUserdetails.otpsettings!.otpexpiry!;
        }
        //rememberMe username here
        onUsernameValidated(userNameController.text);
        if (isPWD_auth.value && isOTP_auth.value) return AuthType.both;
        if (isPWD_auth.value) return AuthType.passwordOnly;
        if (isOTP_auth.value) return AuthType.otpOnly;
      } else {
        AppSnackBar.showError("Error ", json["result"]["message"]);
      }
    }

    return AuthType.none;
  }

  callSignInAPI({bool isSnackBarActive = false}) async {
    if (validateForm()) {
      isLoginLoading.value = true;
      var signInBody = {
        "appname": globalVariableController.PROJECT_NAME.value,
        "username": userNameController.text.toString().trim(),
        "password": generateMd5(userPasswordController.text.toString().trim()),
        "Language": "English",
        "SessionId": getGUID(), //GUID
        "Globalvars": false
      };
      signInBody.addIf(isDuplicate_session, "ClearPreviousSession", true);
      // signInBody.addIf(isPWD_auth.value, "password", generateMd5(userPasswordController.text.toString().trim()));
      signInBody.addIf(isOTP_auth.value, "OtpAuth", "T");
      FocusManager.instance.primaryFocus?.unfocus();
      // LoadingScreen.show();
      var url = Const.getFullARMUrl(ServerConnections.API_SIGNIN);

      var response = await serverConnections.postToServer(
          url: url, body: jsonEncode(signInBody));
      // LogService.writeLog(message: "[-] LoginController => loginButtonClicked() => LoginResponse : $response");

      if (response != "") {
        var json = jsonDecode(response);
        if (json["result"]["success"].toString().toLowerCase() == "true") {
          if (json["result"]["message"].toString() == "Login Successful.") {
            if (isSnackBarActive) {
              Get.back();
            }
            await processSignInDataResponse(json["result"]);
          } else if (json["result"]?.containsKey("OTPLoginKey")) {
            // OTPPage
            otpMsg.value = json["result"]["message"].toString();
            otpLoginKey.value = json["result"]["OTPLoginKey"].toString();
            print("Otpmsg: ${otpMsg.value} \nOtpkey: ${otpLoginKey.value}");
            Get.toNamed(AppRoutes.otp);
          }
        } else if (json["result"]["success"].toString().toLowerCase() ==
                "false" &&
            json["result"].containsKey('duplicate_session')) {
          isDuplicate_session = true;
          showDialogDuplicateSession(json["result"]["message"].toString());
        } else {
          Get.snackbar("Error ", json["result"]["message"],
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white);
        }
      }
      // LoadingScreen.dismiss();
      isLoginLoading.value = false;
    }
  }

  void startOTPTimer() {
    var mins = int.parse(otpExpiryTime.value);
    var totalSeconds = mins * 60;

    otpTimer?.cancel(); // Cancel any existing timer
    isTimerActive.value = true;

    otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (totalSeconds <= 0) {
        timer.cancel();
        timeLeft.value = "00:00";
        isTimerActive.value = false; // mark timer as inactive
      } else {
        totalSeconds--;

        final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
        final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
        timeLeft.value = "$minutes:$seconds";
      }
    });
  }

  callVerifyOTP() async {
    if (validateOTPField()) {
      // LoadingScreen.show();
      isOtpLoading.value = true;

      var url = Const.getFullARMUrl(ServerConnections.API_VALIDATE_OTP);
      var body = {
        "OtpLoginKey": otpLoginKey.value,
        "OTP": otpFieldController.text.toString().trim(),
      };

      var response = await serverConnections.postToServer(
          url: url, body: jsonEncode(body));
      if (response != "") {
        var json = jsonDecode(response);
        if (json["result"]["success"].toString().toLowerCase() == "true") {
          await processSignInDataResponse(json["result"]);
        } else {
          otpErrorText.value = json["result"]["message"].toString();
          /* Get.snackbar("Error ", json["result"]["message"],
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);*/
        }
      }
    }
    isOtpLoading.value = false;

    // LoadingScreen.dismiss();
  }

  processSignInDataResponse(json) async {
    await appStorage.storeValue(AppStorage.TOKEN, json["token"].toString());

    LogService.writeLog(message: "Token : ${json["token"].toString()}");
    await appStorage.storeValue(
        AppStorage.SESSIONID, json["ARMSessionId"].toString());
    await appStorage.storeValue(
        AppStorage.USER_NAME, userNameController.text.trim());
    await appStorage.storeValue(
        AppStorage.NICK_NAME, json["nickname"].toString());

    globalVariableController.NICK_NAME.value = json["nickname"].toString();

    globalVariableController.USER_NAME.value = json["username"].toString();
    globalVariableController.USER_EMAIL.value = json["email_id"].toString();
    //Save Data
    if (rememberMe.value) {
      handleRememberMe(userNameController.text, userPasswordController.text);
      rememberCredentials();
    } else {
      dontRememberCredentials();
    }

    await _processLoginAndGoToHomePage();
  }

  void rememberCredentials() {
    int count = 1;
    try {
      count++;
      var users = appStorage.retrieveValue(AppStorage.USERID) ?? {};
      users[globalVariableController.PROJECT_NAME.value] =
          userNameController.text.trim();
      appStorage.storeValue(AppStorage.USERID, users);

      var passes = appStorage.retrieveValue(AppStorage.USER_PASSWORD) ?? {};
      passes[globalVariableController.PROJECT_NAME.value] =
          userPasswordController.text;
      appStorage.storeValue(AppStorage.USER_PASSWORD, passes);

      var groups = appStorage.retrieveValue(AppStorage.USER_GROUP) ?? {};
      groups[globalVariableController.PROJECT_NAME.value] =
          ddSelectedValue.value;
      appStorage.storeValue(AppStorage.USER_GROUP, groups);
    } catch (e) {
      appStorage.remove(AppStorage.USERID);
      appStorage.remove(AppStorage.USER_PASSWORD);
      appStorage.remove(AppStorage.USER_GROUP);
      if (count < 10) rememberCredentials();
    }
  }

  void dontRememberCredentials() {
    Map users = appStorage.retrieveValue(AppStorage.USERID) ?? {};
    users.remove(globalVariableController.PROJECT_NAME.value);
    appStorage.storeValue(AppStorage.USERID, users);

    var passes = appStorage.retrieveValue(AppStorage.USER_PASSWORD) ?? {};
    passes.remove(globalVariableController.PROJECT_NAME.value);
    appStorage.storeValue(AppStorage.USER_PASSWORD, passes);

    var groups = appStorage.retrieveValue(AppStorage.USER_GROUP) ?? {};
    groups.remove(globalVariableController.PROJECT_NAME.value);
    appStorage.storeValue(AppStorage.USER_GROUP, groups);
  }

  _processLoginAndGoToHomePage() async {
    //mobile Notification
    await _callApiForMobileNotification();
    //connect to Axpert
    await callApiForConnectToAxpert();
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(AppStorage.IS_FIRST_TIME) ?? true) {
      await prefs.setBool(AppStorage.IS_FIRST_TIME, false);
    }
    Get.offAllNamed(AppRoutes.landing);
  }

  _callApiForMobileNotification() async {
    var imei = await PlatformDeviceId.getDeviceId ?? '0';
    // LogService.writeLog(message: "[i] IMEI : $imei");
    var connectBody = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID),
      'firebaseId': fcmId ?? "0",
      'ImeiNo': imei,
    };
    var cUrl = Const.getFullARMUrl(ServerConnections.API_MOBILE_NOTIFICATION);
    var connectResp = await serverConnections.postToServer(
        url: cUrl, body: jsonEncode(connectBody), isBearer: true);
    print("Mobile: " + connectResp);
  }

  Future<void> callApiForConnectToAxpert() async {
    var connectBody = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)
    };
    var cUrl = Const.getFullARMUrl(ServerConnections.API_CONNECTTOAXPERT);
    var connectResp = await serverConnections.postToServer(
        url: cUrl, body: jsonEncode(connectBody), isBearer: true);
    print(connectResp);
    // getArmMenu

    var jsonResp = jsonDecode(connectResp);
    if (jsonResp != "") {
      if (jsonResp['result']['success'].toString() == "true") {
        print("callApiForConnectToAxpert: ${jsonResp.toString()}");
        isAxpertConnectEstablished = true;
        // Get.offAllNamed(Routes.LandingPage);
      } else {
        var message = jsonResp['result']['message'].toString();
        AppSnackBar.showError("Error - Connect To Axpert", message);
      }
    } else {
      AppSnackBar.showError("Error - Connect To Axpert", '');
    }
  }

  callResendOTP() async {
    otpErrorText.value = '';
    otpFieldController.clear();
    isOtpLoading.value = true;
    var url = Const.getFullARMUrl(ServerConnections.API_RESEND_OTP);
    var body = {"OtpLoginKey": otpLoginKey.value};

    var response =
        await serverConnections.postToServer(url: url, body: jsonEncode(body));
    isOtpLoading.value = false;
    startOTPTimer();
    if (response != "") {
      var json = jsonDecode(response);
      if (json["result"]["success"].toString().toLowerCase() == "true") {
        AppSnackBar.showSuccess("Success", json["result"]["message"]);
      } else {
        otpErrorText.value = json["result"]["message"].toString();
        /* Get.snackbar("Error ", json["result"]["message"],
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);*/
      }
    }
  }

  bool validateForm() {
    errPassword.value = errUserName.value = "";
    if (userNameController.text.toString().trim() == "") {
      errUserName.value = "Username is required";
      return false;
    }
    if (isPWD_auth.value) {
      if (userPasswordController.text.toString().trim() == "") {
        errPassword.value = "Password is required";
        return false;
      }
    }
    return true;
  }

  bool validateUserName() {
    errUserName.value = "";
    if (userNameController.text.toString().trim() == "") {
      errUserName.value = "Username is required";
      return false;
    }
    return true;
  }

  bool validateOTPField() {
    otpErrorText.value = "";
    print("OTP text length: ${otpFieldController.text.length}");
    if (otpFieldController.text.length < int.parse(otpChars.value)) {
      otpErrorText.value = "Enter full ${int.parse(otpChars.value)}-digit OTP'";
      print("Enter full ");
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    userNameController.dispose();
    userPasswordController.dispose();
    otpFieldController.dispose();
    super.dispose();
  }

  void toggleUserNameVisibility() {
    errUserName.value = errPassword.value = '';
    isPWD_auth.value = false;
  }

  void onOtpScreenLoad() {
    if (otpErrorText.value.isEmpty && otpFieldController.text.isEmpty) return;
    otpErrorText.value = otpFieldController.text = '';
  }

  void showDialogDuplicateSession(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                "Duplicate Session",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.baseBlue,
                ),
                textAlign: TextAlign.center,
              ),

              16.verticalSpace,

              // Message
              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              24.verticalSpace,

              // Buttons
              Obx(
                () => isLoginLoading.value
                    ? CupertinoActivityIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: FlatButtonWidget(
                              color: AppColors.baseRed,
                              onTap: () {
                                Get.offAllNamed(AppRoutes.login);
                              },
                              label: "NO",
                            ),
                          ),
                          // Confirm button
                          20.horizontalSpace,
                          Expanded(
                            child: FlatButtonWidget(
                              color: AppColors.baseBlue,
                              // style: ElevatedButton.styleFrom(
                              //   backgroundColor: AppColors.baseBlue,
                              //   foregroundColor: Colors.white,
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 24, vertical: 12),
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(12),
                              //   ),
                              //   elevation: 3,
                              // ),
                              onTap: () async {
                                callSignInAPI(isSnackBarActive: true);
                              },
                              label: "Yes",
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
