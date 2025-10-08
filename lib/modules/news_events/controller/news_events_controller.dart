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
  var announcementList = AnnouncementModel.tempData();

  getInitialData() {
    _getAllEvents();
  }

  _getAllEvents() async {
    LogService.writeLog(message: "getAllEvents()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETALLEVENTS,
      "sqlParams": {
        "username": globalVariableController.USER_NAME.value,
        "MONTH": "oct"
      }
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    LogService.writeLog(message: dsResp);
  }
}
