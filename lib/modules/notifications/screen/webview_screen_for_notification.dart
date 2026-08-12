import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/web_view/utils/global_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebviewScreenForNotification extends StatefulWidget {
  const WebviewScreenForNotification({super.key});

  @override
  State<WebviewScreenForNotification> createState() =>
      _WebviewScreenForNotificationState();
}

class _WebviewScreenForNotificationState
    extends State<WebviewScreenForNotification> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final String url = Get.arguments;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: isLoading,
              child: RainbowLoadingWidget(),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(url),
                  ),
                  initialSettings: InAppWebViewSettings(
                    sharedCookiesEnabled: true,
                    javaScriptEnabled: true,
                    domStorageEnabled: true,
                    clearCache: false,
                    supportMultipleWindows: true,
                    transparentBackground: true,
                    // backgroundColor: Colors.white,
                  ),
                  // onWebViewCreated: (controller) async {
                  //   await GlobalCookieManager.syncCookiesTo(url);
                  // },
                  onLoadStart: (controller, url) {
                    setState(() => isLoading = true);
                  },
                  onLoadStop: (controller, url) {
                    setState(() => isLoading = false);
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      setState(() => isLoading = false);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
