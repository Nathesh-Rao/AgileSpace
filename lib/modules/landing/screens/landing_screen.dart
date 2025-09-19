import 'package:axpert_space/modules/web_view/controller/web_view_controller.dart';
import 'package:axpert_space/modules/landing/landing.dart';
import 'package:axpert_space/modules/landing/widgets/landing_drawer_widget.dart';
import 'package:axpert_space/modules/web_view/screen/inapp_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import '../widgets/widgets.dart';

class LandingScreen extends GetView<LandingController> {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = Get.find();
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return; // already popped, no action needed

          if (webViewController.currentIndex.value == 1) {
            // If WebView is visible, go back to Home instead of closing app
            webViewController.currentIndex.value = 0;
          } else {
            // If already on Home, allow normal app close
            final shouldPop = await webViewController.onWillPop();
            /*if (shouldPop) {
                  // Completely close the app
                  SystemNavigator.pop();
                }*/
          }
        },
        child: IndexedStack(
          index: webViewController.currentIndex.value,
          children: [
            AdvancedDrawer(
              backdrop: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              controller: controller.landingDrawerController,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              animateChildDecoration: true,
              rtlOpening: false,
              // openScale: 1.0,
              disabledGestures: false,
              childDecoration: const BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              drawer: LandingDrawerWidget(),
              child: Scaffold(
                body: PageView.builder(
                    itemCount: 4,
                    controller: controller.landingPageViewController,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return controller.landingPageTabs[index];
                    }),
                bottomNavigationBar: BottomBarWidget(),
              ),
            ),
            Obx(() =>
                InApplicationWebViewer(webViewController.currentUrl.value))
          ],
        ),
      ),
    );
  }
}
