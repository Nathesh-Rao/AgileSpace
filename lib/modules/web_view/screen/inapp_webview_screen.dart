import 'dart:async';
import 'dart:io';
import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/common/widgets/flat_button_widget.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/modules/landing/landing.dart';
import 'package:axpert_space/routes/app_routes.dart';
import 'package:file_downloader_flutter/file_downloader_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../controller/web_view_controller.dart';
import '../../../common/log_service/log_services.dart';

class InApplicationWebViewer extends StatefulWidget {
  InApplicationWebViewer(this.data, {super.key});

  WebViewController webViewController = Get.find();
  String data;

  @override
  State<InApplicationWebViewer> createState() => _InApplicationWebViewerState();
}

class _InApplicationWebViewerState extends State<InApplicationWebViewer> {
  dynamic argumentData = Get.arguments;
  // MenuHomePageController menuHomePageController = Get.find();
  LandingController landingPageController = Get.find();
  Map<int, InAppWebViewController> windowControllers = {};
  BuildContext? context_popUpScreen;

  // final Completer<InAppWebViewController> _controller = Completer<InAppWebViewController>();
  // late InAppWebViewController _webViewController;

  // final _key = UniqueKey();
  var hasAppBar = false;
  late StreamSubscription subscription;
  CookieManager cookieManager = CookieManager.instance();
  final imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'ico',
    'xlsx',
    'xls',
    'docx',
    'doc',
    'pdf'
  ];
  bool isCalendarPage = false;
  bool _showButton = false;
  bool _handled = false;
  bool _longPressActive = false;
  double _startY = 0;
  Timer? _longPressTimer;

  @override
  void initState() {
    super.initState();
    try {
      if (argumentData != null) widget.data = argumentData[0];
      if (argumentData != null) hasAppBar = argumentData[1] ?? false;
    } catch (e) {}
    // widget.data = "https://amazon.in"
    debugPrint(widget.data);
    clearCookie();
  }

  @override
  void dispose() {
    super.dispose();
    _longPressTimer?.cancel(); // kill timer safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      landingPageController.switchPage.value = false;
    });
    //Navigator.pop(context);
  }

  InAppWebViewSettings settings = InAppWebViewSettings(
    transparentBackground: true,
    javaScriptEnabled: true,
    // incognito: true,
    javaScriptCanOpenWindowsAutomatically: true,
    useOnDownloadStart: true,
    domStorageEnabled: true,
    useShouldOverrideUrlLoading: true,
    // mediaPlaybackRequiresUserGesture: false,
    useHybridComposition: false,
    hardwareAcceleration: false,
    geolocationEnabled: true,
    clearCache: false,

    supportMultipleWindows: true,
  );

  perform_backButtonClick() async {
    if (isCalendarPage) {
      widget.webViewController.closeWebView();
      return true;
    }

    bool handledInWeb = await widget
            .webViewController.inAppWebViewController.value!
            .evaluateJavascript(source: """
      (function() {
        var btn = document.querySelector('.appBackBtn');
        if (btn) {
          btn.click();
          return true;   //handled inside web
        }
        return false;    //button not found
      })();
    """) ??
        false;

    if (!handledInWeb) {
      widget.webViewController.closeWebView();
      return true;
    }

    return false;
  }

  void _download(String url) async {
    try {
      debugPrint("download Url: $url");
      String fname = url.split('/').last.split('.').first;
      debugPrint("download FileName: $fname");
      await FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _download_old(String url) async {
    if (Platform.isAndroid) {
      debugPrint("ANDROID download---------------------------->");
      try {
        debugPrint("download Url: $url");
        String fname = url.split('/').last.split('.').first;
        debugPrint("download FileName: $fname");
        FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    if (Platform.isIOS) {
      debugPrint("IOS download---------------------------->");
      var status = await Permission.storage.request().isGranted;
      try {
        if (status) {
          Directory documents = await getApplicationDocumentsDirectory();
          debugPrint(documents.path);
          String fname = url.split('/').last.split('.').first;
          debugPrint("download FileName: $fname");
          FileDownloaderFlutter().urlFileSaver(url: url, fileName: fname);
        } else {
          debugPrint("Permission Denied");
        }
      } catch (e) {
        debugPrint("IOS download error $e");
      }
    }
  }

  Future<void> _onLongSwipe() async {
    debugPrint("Longpress");
    if (_handled) return;
    _handled = true;

    setState(() => _showButton = true);

    // auto hide after 3 sec
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _showButton = false);
      _handled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (await _webViewController.canGoBack()) {
        // _webViewController.goBack();
        if (widget.webViewController.currentIndex == 1) {
          bool val = perform_backButtonClick();
          return Future.value(val);
          /*widget.webViewController.closeWebView();
          if (widget.webViewController.inAppWebViewController.value == null) return Future.value(true);

          if (await widget.webViewController.inAppWebViewController.value!.canGoBack()) {
            widget.webViewController.inAppWebViewController.value!.goBack();
            return Future.value(false);
          } else {
            //return Future.value(false);
            return Future.value(true);
          }*/
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: hasAppBar == true
            ? AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                centerTitle: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/axAppLogo.png",
                      // height: 25,
                    ),
                  ],
                ),
              )
            // : AppBar(
            //     actions: [Icon(Icons.cancel)],
            //   ),

            : PreferredSize(
                preferredSize: Size(double.infinity, 50.h),
                child: SizedBox(
                  height: 50.h,
                ),
              ),
        body: SafeArea(
          child: Builder(builder: (BuildContext context) {
            return Stack(children: <Widget>[
              InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri.uri(Uri.parse(widget.data))),
                initialSettings: settings,
                onWebViewCreated: (controller) {
                  // _webViewController = controller;
                  widget.webViewController.inAppWebViewController.value =
                      controller;
                },
                onLoadStart: (controller, url) {
                  url.toString().toLowerCase().contains("dcalendar")
                      ? isCalendarPage = true
                      : isCalendarPage = false;

                  setState(() {
                    widget.webViewController.isProgressBarActive.value = true;
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    widget.webViewController.isProgressBarActive.value = false;
                  });
                },
                onGeolocationPermissionsShowPrompt:
                    (InAppWebViewController controller, String origin) async {
                  var status = await Permission.locationWhenInUse.status;

                  if (status.isGranted) {
                    return GeolocationPermissionShowPromptResponse(
                      origin: origin,
                      allow: true,
                      retain: true,
                    );
                  } else {
                    requestLocationPermission();
                    return GeolocationPermissionShowPromptResponse(
                      origin: origin,
                      allow: false,
                      retain: false,
                    );
                  }
                },
                onDownloadStartRequest: (controller, downloadStartRequest) {
                  LogService.writeLog(
                      message:
                          "onDownloadStartRequest\nwith requested url: ${downloadStartRequest.url.toString()}");
                  debugPrint("Download...");
                  debugPrint(
                      "Requested url: ${downloadStartRequest.url.toString()}");
                  _download(downloadStartRequest.url.toString());
                  // _downloadToDevice("url");
                },
                onConsoleMessage: (controller, consoleMessage) {
                  // LogService.writeLog(message: "onConsoleMessage: ${consoleMessage.toString()}");

                  debugPrint("Console Message received...");
                  debugPrint(consoleMessage.toString());
                  if (consoleMessage
                      .toString()
                      .contains("axm_mainpageloaded")) {
                    try {
                      // if (menuHomePageController.switchPage.value == true) {
                      //   menuHomePageController.switchPage.toggle();
                      // } else {
                      //   Get.back();
                      // }

                      widget.webViewController.closeWebView();
                    } catch (e) {}
                  }
                },
                onProgressChanged: (controller, value) {
                  LogService.writeLog(
                      message: "onProgressChanged: value=> $value");

                  debugPrint('Progress---: $value : DT ${DateTime.now()}');
                  if (value == 100) {
                    setState(() {
                      widget.webViewController.isProgressBarActive.value =
                          false;
                    });
                  }
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  debugPrint("Override url: $uri");
                  LogService.writeLog(
                      message: "shouldOverrideUrlLoading: url=> $uri");
                  if (uri.toString().toLowerCase().contains("sess.aspx")) {
                    await controller
                        .loadUrl(
                          urlRequest: URLRequest(
                            url: WebUri("$uri?axmain=true"),
                          ),
                        )
                        .then((_) {});
                    //showSignOutDialog();
                    widget.webViewController.showSignOutDialog_sessionExpired();
                  }

                  if (imageExtensions
                      .any((ext) => uri.toString().endsWith(ext))) {
                    _download(uri.toString());
                    // _downloadToDevice("url");

                    return Future.value(NavigationActionPolicy.CANCEL);
                  }
                  return Future.value(NavigationActionPolicy.ALLOW);
                },
                onCreateWindow: (controller, createWindowRequest) async {
                  final windowId = createWindowRequest.windowId;
                  debugPrint("newWindowCreated");

                  Get.to(
                      () => NewWindowPage(
                            windowId: windowId,
                            onWindowCreated: (newController) {
                              windowControllers[windowId] = newController;
                              context_popUpScreen = context;
                            },
                          ),
                      transition: Transition.cupertino,
                      duration: Duration(milliseconds: 500));
                  return true; // Allow the window creation
                },
              ),
              Positioned.fill(
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (event) {
                    _startY = event.position.dy;
                    _longPressTimer =
                        Timer(const Duration(milliseconds: 300), () {
                      _longPressActive = true;
                    });
                  },
                  onPointerMove: (event) {
                    if (_longPressActive) {
                      final dy = event.position.dy - _startY;
                      if (dy > 100 && !_handled) {
                        // _onLongSwipeTriggered();
                        _onLongSwipe();
                      }
                    }
                  },
                  onPointerUp: (_) {
                    _longPressTimer?.cancel();
                    _longPressActive = false;
                  },
                ),
              ),
              Obx(
                () => widget.webViewController.isProgressBarActive.value
                    ? Container(
                        color: Colors.white,
                        child: Center(
                          child: SpinKitRotatingCircle(
                            size: 40,
                            itemBuilder: (context, index) {
                              final colors = [
                                AppColors.baseBlue,
                                AppColors.blue10,
                                AppColors.blue9,
                              ];
                              final color = colors[index % colors.length];
                              return DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: color, shape: BoxShape.circle));
                            },
                          ),
                        ))
                    : Stack(),
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: Visibility(
                      visible: false,
                      child: GestureDetector(
                          onTap: perform_backButtonClick,
                          child: Icon(Icons.cancel)))),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: _showButton ? 20.0 : -100.0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _showButton ? 1.0 : 0.0,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        widget.webViewController.closeWebView();
                      },
                      child: const Icon(Icons.home, size: 32),
                    ),
                  ),
                ),
              ),
              Obx(
                () => widget.webViewController.isFileDownloading.value
                    ? Container(
                        color: Colors.black
                            .withValues(alpha: 0.6), // dim background
                        child: Center(
                          child: Lottie.asset(
                            "assets/lotties/download.json",
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Stack(),
              ),
            ]);
          }),
        ),
        //floatingActionButton: favoriteButton(),
      ),
    );
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      // Request permission
      if (await Permission.locationWhenInUse.request().isGranted) {
        debugPrint("Location permission granted.");
      } else {
        debugPrint("Location permission denied.");
        showPermissionDialog();
      }
    }
  }

  void showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location Permission Required"),
          content: Text(
              "This feature requires location access. Please enable location permissions in settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Opens app settings to enable permissions
                Navigator.of(context).pop();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  void clearCookie() async {
    await cookieManager.deleteAllCookies();
    print("Cookie cleared");
  }

  void showSignOutDialog() {
    widget.webViewController
        .signOut(url: Const.getFullWebUrl("aspx/AxMain.aspx?signout=true"));

    Get.dialog(
      barrierColor: Colors.black26,
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
                "Session Expired",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.baseBlue,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                "Your session has expired. Please log in again to continue.",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: FlatButtonWidget(
                      color: AppColors.baseRed,
                      onTap: () {
                        widget.webViewController.signOut_withoutDialog();
                        // Get.offAllNamed(AppRoutes.login);
                      },
                      label: "Logout",
                    ),
                  ),
                  // Confirm button
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Get.defaultDialog(
    //   barrierDismissible: false,
    //   titleStyle: TextStyle(color: AppColors.baseBlue),
    //   titlePadding: EdgeInsets.only(
    //     top: 20,
    //   ),
    //   contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    //   title: "Session Expired",
    //   middleText: "Your session has expired. Please log in again to continue.",
    //   confirm: ElevatedButton(
    //       onPressed: () async {
    //         widget.webViewController.signOut_withoutDialog();
    //       },
    //       child: Text("Login")),
    // );
  }
}

class NewWindowPage extends StatefulWidget {
  final int windowId;
  final Function(InAppWebViewController) onWindowCreated;

  const NewWindowPage({
    super.key,
    required this.windowId,
    required this.onWindowCreated,
  });

  @override
  _NewWindowPageState createState() => _NewWindowPageState();
}

class _NewWindowPageState extends State<NewWindowPage> {
  late InAppWebViewController newWebViewController;

  @override
  Widget build(BuildContext context) {
    debugPrint("new-Window => ${widget.windowId}");
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
            ),
            windowId: widget.windowId,
            // Associate this WebView with the windowId
            onWebViewCreated: (controller) {
              newWebViewController = controller;
              widget.onWindowCreated(controller);
            },
            onConsoleMessage: (controller, consoleMessage) {
              debugPrint("Console Message_new_window $consoleMessage");
            },
            onDownloadStartRequest: (controller, downloadStartRequest) async {
              await StorageUtils.downloadFile_inAppWebView(
                  controller: controller,
                  downloadStartRequest: downloadStartRequest,
                  onDownloadComplete: (path) {
                    Get.until(
                        (route) => route.settings.name == AppRoutes.landing);
                    debugPrint("Download path => $path");
                  },
                  onDownloadError: (e) {
                    Get.until(
                        (route) => route.settings.name == AppRoutes.landing);
                    debugPrint("Download Error => $e");
                  });
            }

            // onPageCommitVisible: (controller,consolemsg){
            //
            // },
            ),
      ),
    );
  }
}
