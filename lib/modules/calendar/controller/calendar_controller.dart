import 'dart:convert';

import 'package:axpert_space/core/app_storage/app_storage.dart';
import 'package:axpert_space/core/core.dart';
import 'package:axpert_space/data/data_source/datasource_services.dart';
import 'package:axpert_space/modules/calendar/models/event_model.dart';
import 'package:axpert_space/modules/calendar/models/meeting_model.dart';
import 'package:axpert_space/modules/calendar/models/task_by_day_model.dart';
import 'package:axpert_space/modules/web_view/controller/web_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/log_service/log_services.dart';
import '../../../core/constants/const.dart';
import '../../../core/utils/server_connections/server_connections.dart';

class CalendarController extends GetxController {
  var calendarViewSwitch = false.obs;
  var calendarEventLoading = false.obs;

  RxList<EventModel> eventsList = <EventModel>[].obs;
  RxList<TaskByDayModel> taskList = <TaskByDayModel>[].obs;

  AppStorage appStorage = AppStorage();
  ServerConnections serverConnections = ServerConnections();
  DateTime todayDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  RxList<Meeting> meetingList = <Meeting>[].obs;
  WebViewController webViewController = Get.find();
  void switchCalendarView() {
    calendarViewSwitch.toggle();
  }

  Future<void> getAllData() async {
    // await getTaskByDay();
    await getEventsByDay();
    // getMeetingsFromEvents();
  }

  Future<void> getEventsByDay() async {
    // eventsList.value = [];
    calendarEventLoading.value = true;
    LogService.writeLog(message: "getEventsByDay()");
    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETEVENTSBYDAY,
      "sqlParams": {
        "username": globalVariableController.USER_NAME.value,
        "date": DateUtilsHelper.getFormattedDateYMD(selectedDate.toString())
      }
      // "sqlParams": {"username": "syamala", "date": "2025-09-15"}
    };
    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));
    eventsList.value = [];
    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];

        LogService.writeLog(
            message: "Calendar dsDataList ${dsDataList.length.toString()}");
        for (var item in dsDataList) {
          try {
            if (item != null) {
              var event = EventModel.fromJson(item);

              if (event.recordType.toLowerCase() == "leave") {
                eventsList.clear();
                eventsList.add(event);
                calendarEventLoading.value = false;
                return;
              }

              eventsList.add(event);
            }
          } catch (e) {
            debugPrint(" $e");
          }
        }

        LogService.writeLog(
            message: "Calendar Events ${eventsList.length.toString()}");
      }
    }

    calendarEventLoading.value = false;
  }

  // getTaskByDay() async {
  //   taskList.value = [];
  //   calendarEventLoading.value = true;
  //   LogService.writeLog(
  //       message:
  //           "getTaskByDay() => Username => ${globalVariableController.USER_NAME.value}");
  //   var username = globalVariableController.USER_NAME.value;
  //   var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
  //   var body = {
  //     "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
  //     "appname": globalVariableController.PROJECT_NAME.value,
  //     "datasource": DataSourceServices.DS_GETTASKSBYDAY,
  //     "sqlParams": {
  //       "username": username,
  //       "date": DateUtilsHelper.getFormattedDateYMD(selectedDate.toString())
  //     }
  //   };
  //   var dsResp = await serverConnections.postToServer(
  //       url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

  //   if (dsResp != "") {
  //     var jsonDSResp = jsonDecode(dsResp);
  //     if (jsonDSResp['result']['success'].toString() == "true") {
  //       var dsDataList = jsonDSResp['result']['data'];
  //       for (var item in dsDataList) {
  //         try {
  //           if (item != null) {
  //             taskList.add(TaskByDayModel.fromJson(item));
  //           }
  //         } catch (e) {
  //           debugPrint(" $e");
  //         }
  //       }
  //     }
  //   }

  //   calendarEventLoading.value = false;
  // }

  // getMeetingsFromEvents() {
  //   meetingList.value = [];

  //   // for (var i = 0; i < eventsList.length; i++) {
  //   //   var m = eventsList[i];

  //   //   meetingList.add(Meeting(
  //   //     m.eventName,
  //   //     m.description,
  //   //     m.toDate.copyWithHourOffset(i),
  //   //     m.toDate.copyWithHourOffset(3 + i),
  //   //     AppColors.getRandomColor(),
  //   //     m.isAllDay.toString().contains("yes") ? true : false,
  //   //   ));
  //   // }
  // }

  void navigateToCreateTask() {
    webViewController.navigateToCreateTask();
  }
}
