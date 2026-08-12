import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class InternetConnectivity extends GetxController {
  var isConnected = false.obs;

  InternetConnectivity() {
    connectivity_listen();
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      isConnected.value = true;
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      isConnected.value = true;
      return true;
    }
    isConnected.value = false;
    showError();
    return false;
  }

  get connectionStatus => check();

  void showError() {
    Get.defaultDialog(
      contentPadding: EdgeInsets.all(10),
      titlePadding: EdgeInsets.only(top: 20),
      title: "No Connection!",
      middleText: "Please check your internet connectivity",
      barrierDismissible: false,
      //"No Internet Connections are available.\nPlease try again later",
      confirm: ElevatedButton(
          onPressed: () async {
            Get.back();
            Timer(Duration(milliseconds: 400), () async {
              check().then((value) {
                if (value == true) {
                  doRefresh(Get.currentRoute);
                }
              });
            });
          },
          child: Text("Ok")),
      // cancel: TextButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     child: Text("Ok"))
    );
  }

  connectivity_listen() async {
    Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> result) async {
        // LogService.writeLog(message: "connectivity listen $result");
        if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
          isConnected.value = true;
        } else {
          isConnected.value = false;
          showError();
        }
      },
    );
  }
}

doRefresh(String currentRoute) {
  print(currentRoute);
  switch (currentRoute) {
    case AppRoutes.login:
      break;
    default:
      break;
  }
}
