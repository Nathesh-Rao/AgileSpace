import 'dart:convert';
import 'dart:io';

import 'package:axpert_space/modules/auth/controllers/auth_controller.dart';
import 'package:axpert_space/modules/landing/controllers/landing_controller.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/log_service/log_services.dart';
import '../../../core/core.dart';
import '../../../core/utils/internet_connections/internet_connectivity.dart';

class WebViewController extends GetxController {
  InternetConnectivity internetConnectivity = Get.find();
  var currentIndex = 0.obs;
  var currentUrl = ''.obs;
  var previousUrl = '';
  var isFileDownloading = false.obs;
  var isWebViewLoading = false.obs;
  var isProgressBarActive = true.obs;
  var inAppWebViewController = Rxn<InAppWebViewController>();
  ServerConnections serverConnections = ServerConnections();
  AppStorage appStorage = AppStorage();
  DateTime currentBackPressTime = DateTime.now();

  openWebView({required String url}) async {
    AuthController authController = Get.find();
    if (!authController.isAxpertConnectEstablished) {
      await authController.callApiForConnectToAxpert();
    }

    if (authController.isAxpertConnectEstablished) {
      currentUrl.value = url;
      LogService.writeLog(
          message: "WebViewController - openWebView - url => $url");
      await inAppWebViewController.value!
          .loadUrl(
            urlRequest: URLRequest(
              url: WebUri(url),
            ),
          )
          .then((_) {});
      currentIndex.value = 1;
    }
  }

  closeWebView() {
    currentIndex.value = 0;
    isProgressBarActive.value = true;
  }

  signOut({required String url}) async {
    // currentUrl.value = url;

    await inAppWebViewController.value!
        .loadUrl(
          urlRequest: URLRequest(
            url: WebUri(url),
          ),
        )
        .then((_) {});
  }

  void showSignOutDialog_sessionExpired() {
    signOut(url: Const.getFullWebUrl("aspx/AxMain.aspx?signout=true"));
    Get.defaultDialog(
      barrierDismissible: false,
      titleStyle: TextStyle(color: AppColors.primaryActionIconColorBlue),
      titlePadding: EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      title: "Session Expired",
      content: PopScope(
        canPop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Your session has expired. Please log in again to continue."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                signOut_withoutDialog();
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  signOut_withoutDialog() async {
    var body = {'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)};
    var url = Const.getFullARMUrl(ServerConnections.API_SIGNOUT);
    try {
      // await FirebaseAuth.instance.signOut();
      // await GoogleSignIn().signOut();
      clearCacheData();
    } catch (e) {
      debugPrint(e.toString());
    }
    appStorage.storeValue(AppStorage.USER_NAME, "");
    await serverConnections.postToServer(url: url, body: jsonEncode(body));
    // LoadingScreen.dismiss();
    //webViewController.signOut(url: Const.getFullWebUrl("aspx/AxMain.aspx?signout=true"));
    Get.offAllNamed(AppRoutes.login);
  }

  clearCacheData() async {
    var tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<bool> onWillPop() {
    try {
      LandingController landingController = Get.find();
      if (landingController.switchPage.value == true) {
        landingController.switchPage.toggle();
        return Future.value(false);
      }
    } catch (e) {}
    DateTime now = DateTime.now();
    // if (bottomIndex.value != 0) {
    //   bottomIndex.value = 0;
    //   return Future.value(false);
    // }
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Get.rawSnackbar(
          messageText: Center(
            child: Text(
              "Press back again to exit",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          margin: EdgeInsets.only(left: 10, right: 10),
          borderRadius: 10,
          backgroundColor: Colors.red,
          isDismissible: true,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM);
      return Future.value(false);
    } else {
      if (Get.isSnackbarOpen) Get.back();
      // SystemNavigator.pop(animated: true);
      exit(0);
      // return Future.value(true);
    }
  }

  void openItemClick(itemModel) async {
    if (await internetConnectivity.connectionStatus) {
      if (itemModel.url != "") {
        openWebView(url: Const.getFullWebUrl(itemModel.url));
      }
    }
  }
}
