import 'dart:collection';
import 'dart:convert';
import 'package:axpert_space/modules/attendance/attendance.dart';
import 'package:axpert_space/modules/web_view/controller/web_view_controller.dart';
import 'package:axpert_space/common/log_service/log_services.dart';
import 'package:axpert_space/core/utils/internet_connections/internet_connectivity.dart';
import 'package:axpert_space/modules/landing/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:material_icons_named/material_icons_named.dart';
import '../../../core/core.dart';
import '../../../routes/app_routes.dart';
import '../models/landing_menu_item_model.dart';
import '../screens/tabs/tabs.dart';

class LandingController extends GetxController {
  var dashboardIcon = "assets/icons/bottom_nav/dashboard_icon.png";
  var payAttendanceIcon = "assets/icons/bottom_nav/pay_attendance_icon.png";
  var calendarIcon = "assets/icons/bottom_nav/calendar_icon.png";
  var settingsIcon = "assets/icons/bottom_nav/settings_icon.png";
  var activeTaskIcon = "assets/icons/common/active_list.png";

  PageController landingPageViewController = PageController();
  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  WebViewController webViewController = Get.find();
  InternetConnectivity internetConnectivity = Get.find();
  AttendanceController attendanceController = Get.find();
  final ScrollController drawerScrollController = ScrollController();
  var drawerScrollProgress = 0.0.obs;
  var drawerHeadExpandSwitch = false.obs;
  var switchPage = false.obs;
  var isSignOutLoading = false.obs;
  List<MenuItemModel> menuListMain = [];
  var menuFinalList = [].obs;
  var landingPageTabs = [
    LandingTaskTab(),
    LandingPayAndAttendanceTab(),
    LandingActiveTaskTab(),
    LandingCalendarTab(),
    LandingSettingsTab()
  ];
  var iconList = [
    Icons.calendar_month_outlined,
    Icons.today_outlined,
    Icons.date_range_outlined,
    Icons.event_repeat_outlined,
    Icons.perm_contact_calendar_outlined,
    Icons.event_note_outlined,
    Icons.event_available_outlined,
    Icons.event_busy_outlined,
  ];
  final landingDrawerController = AdvancedDrawerController();

  @override
  void onInit() {
    super.onInit(); // always call super
    drawerScrollController.addListener(_drawerScrollListener);
    debugPrint("Landing Controller initialized");
    getMenuList();
  }

  resetDrawerHeadSwitch() {
    drawerHeadExpandSwitch.value = false;
  }

  switchDrawerHeadSwitchValue() {
    drawerHeadExpandSwitch.toggle();
  }

  void _drawerScrollListener() {
    if (!drawerScrollController.hasClients) return;
    final maxScroll = drawerScrollController.position.maxScrollExtent;
    final currentScroll = drawerScrollController.position.pixels;
    drawerScrollProgress.value =
        maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.1, 1.0) : 0.0;
  }

  onPageViewChange(int newIndex) {
    currentBottomBarIndex.value = newIndex;
  }

  var currentBottomBarIndex = 0.obs;

  setBottomBarIndex(int newIndex) {
    if (currentBottomBarIndex.value == newIndex) return;

    if ((currentBottomBarIndex.value - newIndex).abs() == 1) {
      landingPageViewController.animateToPage(newIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      landingPageViewController.jumpToPage(newIndex);
    }
    currentBottomBarIndex.value = newIndex;
  }

  void getMenuList() async {
    LogService.writeLog(message: "GetMenuList started");
    var mUrl = Const.getFullARMUrl(ServerConnections.API_GET_MENU_V2);
    var conectBody = {
      'ARMSessionId': appStorage.retrieveValue(AppStorage.SESSIONID)
    };
    var menuResp = await serverConnections.postToServer(
        url: mUrl, body: jsonEncode(conectBody), isBearer: true);
    if (menuResp != "") {
      debugPrint("menuResp $menuResp");
      var menuJson = jsonDecode(menuResp);
      if (menuJson['result']['success'].toString() == "true") {
        debugPrint("getMenuList => ${menuJson['result']["data"]}");
        for (var menuItem in menuJson['result']["data"]) {
          try {
            MenuItemModel mi = MenuItemModel.fromJson(menuItem);
            menuListMain.add(mi);
          } catch (e) {
            // AppSnackBar.showError("Error ", menuJson["result"]["message"]);
          }
        }
      }
    }
    reOrganise(menuListMain);
  }

  void reOrganise(menuList) {
    LogService.writeLog(message: "GetMenuList reOrganise started");
    var headaParentlist = {};
    var mapMenulist = {};
    for (var item in menuList) {
      var parent = item.parent;
      if (parent != "") {
        headaParentlist[item.name] = parent;
        String parentTree = getParentHierarchy(headaParentlist, item.name);
        item.parent_tree = parentTree;
      }
      mapMenulist[item.name] = item;
    }

    var keysToRemove = <String>[];

    //To get the parent tree reverse the Map
    final reverseM =
        LinkedHashMap.fromEntries(mapMenulist.entries.toList().reversed);
    reverseM.forEach((key, value) {
      try {
        MenuItemModel md = value;
        var parent = md.parent;
        if (parent != "") {
          reverseM[parent].childList.insert(0, md);
          keysToRemove.add(key);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    //Remove the record that was added to its parent.
    for (var key in keysToRemove) {
      reverseM.remove(key);
    }

    // Once again reverse the Map to get the actual order.
    final mapFinallist =
        LinkedHashMap.fromEntries(reverseM.entries.toList().reversed);

    // Add the Map value to List
    List<MenuItemModel> newList = [];
    mapFinallist.forEach((k, v) => newList.add(v as MenuItemModel));
    menuFinalList.value = newList;
  }

  String getParentHierarchy(Map headaParentlist, String name) {
    String parentTree = "";
    String parent = headaParentlist[name];
    while (parent != "") {
      parentTree += parentTree == "" ? parent : "~$parent";
      parent = headaParentlist[parent] ?? "";
    }
    return parentTree;
  }

  getDrawerTileList() {
    List<Widget> menuList = [];

    var a = menuFinalList.map(buildInnerListTile).toList();
    menuList.addAll(a);
    LogService.writeLog(
        message:
            "GetMenuList reOrganise   getDrawerTileList() count ${menuList.length}");

    return menuList;
  }

  Widget buildInnerListTile(tile, {double leftPadding = 15}) {
    return LandingDrawerMenuWidget(
      tile: tile,
      leftPadding: leftPadding,
    );
  }

  IconData? generateIcon(subMenu, index) {
    var iconName = subMenu.icon;

    if (iconName.contains("material-icons")) {
      iconName = iconName.replaceAll("|material-icons", "");
      return materialIcons[iconName];
    } else {
      switch (subMenu.pagetype.trim() != ""
          ? subMenu.pagetype.trim().toUpperCase()[0]
          : subMenu.pagetype.trim()) {
        case "T":
          return Icons.assignment;
        case "I":
          return Icons.view_list;
        case "W":
        case "H":
          return Icons.code;
        default:
          return iconList[index++ % 8];
      }
    }
  }

  void openWebView(String item) {
    try {
      var url = Const.getFullWebUrl('aspx/AxMain.aspx?authKey=AXPERT-') +
          appStorage.retrieveValue(AppStorage.SESSIONID);
      var jsonData = jsonDecode(item);
      var messageClicked = jsonData["msg_onclick"] ?? "";
      print(messageClicked);
      if (messageClicked != "") {
        var jsonMainClickData = jsonDecode(messageClicked);
        print(jsonMainClickData['type']);
        var msgType = jsonMainClickData['type'];
        var msgValue = jsonMainClickData['value']
            .replaceAll("transid~", "")
            .replaceAll("ivname~", "");
        url += "&pname=" + msgType + msgValue;
        print(url);
        // Get.toNamed(Routes.InApplicationWebViewer, arguments: [url]);
        webViewController.openWebView(url: url);
      }
    } catch (e) {
      print("Can not open web view: error- $e");
    }
    // Get.toNamed(Routes.InApplicationWebViewer);
  }

  //   void openItemClick(itemModel) async {
  //   if (await internetConnectivity.connectionStatus) {
  //     if (itemModel.url != "") {
  //       webViewController.openWebView(url: Const.getFullWebUrl(itemModel.url));
  //     }
  //   }
  // }

  void openItemClick(itemModel) async {
    if (await internetConnectivity.connectionStatus) {
      debugPrint("itemmdel.url => ${itemModel.url}");
      if (itemModel.url != "") {
        attendanceController.handleOnClosePunchinPunchOut(itemModel.url);

        webViewController.openWebView(url: Const.getFullWebUrl(itemModel.url));
      }
    }
  }

  @override
  void dispose() {
    drawerScrollController.removeListener(_drawerScrollListener);
    drawerScrollController.dispose();
    landingPageViewController.dispose();
    super.dispose();
  }

  startLogOut() async {
    isSignOutLoading.value = true;
    await webViewController.signOut();
    await webViewController.signOut_withoutDialog();
    isSignOutLoading.value = false;
  }
}
