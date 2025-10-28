import 'dart:convert';

import 'package:axpert_space/modules/news_events/models/announcement_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/log_service/log_services.dart';
import '../../../core/core.dart';
import '../../../data/data_source/datasource_services.dart';

class NewsEventsController extends GetxController {
  var pageController = PageController();
  RxInt currentIndex = 0.obs;
  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  // var announcementList = AnnouncementModel.tempData();
  RxList<AnnouncementModel> announcementList = <AnnouncementModel>[].obs;
  var isEventsLoading = false.obs;
  getInitialData() {
    _getAllEvents();
  }

  _getAllEvents() async {
    LogService.writeLog(message: "getAllEvents()");
    isEventsLoading.value = true;
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETALLEVENTS,
      "sqlParams": {
        "username": globalVariableController.USER_NAME.value,
        "Month": DateUtilsHelper.getShortMonthName(
            DateTime.now().toString().split(" ")[0])
      }
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        announcementList.clear();
        for (var item in dsDataList) {
          try {
            var event = AnnouncementModel.fromJson(item);
            announcementList.add(event);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
    }

    isEventsLoading.value = false;

    LogService.writeLog(message: dsResp);
  }

  String getImageFromEventType(String eventTYpe) {
    if (eventTYpe.toLowerCase().contains("birthday")) {
      return "assets/images/common/bday2.jpg";
    }

    return 'assets/images/common/news1.jpg';
  }

  String getLottieFromEventType(String eventTYpe) {
    return 'assets/lotties/bday.json';
  }
}
