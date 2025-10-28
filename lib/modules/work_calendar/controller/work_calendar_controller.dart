import 'dart:async';
import 'dart:convert';

import 'package:axpert_space/modules/work_calendar/model/off_days_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/core.dart';
import '../../../data/data_source/datasource_services.dart';

class WorkCalendarController extends GetxController {
  var appStorage = AppStorage();
  var serverConnections = ServerConnections();
  var isOffDaysLoading = false.obs;
  var dateClicked = false.obs;
  var dateInfo = ''.obs;
  Timer? _timer;

  DateTime selectedDate = DateTime.now();

  List<OffDaysModel> offDaysList = [];
  Map<DateTime, String> karnatakaHolidays = {};

  Map<DateTime, int> calendarMap = {
    ...generateWeekendData(DateTime.now().year, 1),
  };
  initializeOffDays() async {
    if (karnatakaHolidays.isNotEmpty) return;
    isOffDaysLoading.value = true;
    offDaysList = [];
    offDaysList = await getAllOffDays();
    _parseOffDaysList();
    isOffDaysLoading.value = false;
  }

  Future<List<OffDaysModel>> getAllOffDays() async {
    List<OffDaysModel> offDaysList = [];

    var dataSourceUrl = Const.getFullARMUrl(ServerConnections.API_DATASOURCE);
    var body = {
      "ARMSessionId": appStorage.retrieveValue(AppStorage.SESSIONID),
      "appname": globalVariableController.PROJECT_NAME.value,
      "datasource": DataSourceServices.DS_GETOFFDAYS,
      "sqlParams": {"year": "2025"}
    };

    var dsResp = await serverConnections.postToServer(
        url: dataSourceUrl, isBearer: true, body: jsonEncode(body));

    if (dsResp != "") {
      var jsonDSResp = jsonDecode(dsResp);
      if (jsonDSResp['result']['success'].toString() == "true") {
        var dsDataList = jsonDSResp['result']['data'];
        try {
          for (var i in dsDataList) {
            offDaysList.add(OffDaysModel.fromJson(i));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }

    return offDaysList;
  }

  DateTime parseDate(String dateString) {
    final parts = dateString.split('-');
    if (parts.length != 3) {
      throw FormatException('Invalid date format, expected dd-MM-yyyy');
    }

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }

  static Map<DateTime, int> generateWeekendData(int year, int value) {
    final Map<DateTime, int> weekendData = {};
    DateTime date = DateTime(year, 1, 1);

    while (date.year == year) {
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        weekendData[DateTime(date.year, date.month, date.day)] = value;
      }
      date = date.add(const Duration(days: 1));
    }

    return weekendData;
  }

  onDateClick(DateTime value, {bool cancelTimer = false}) {
    selectedDate = value;

    if (karnatakaHolidays[value] == null) {
      dateClicked.value = false;
      _timer!.cancel();
      return;
    }

    if (dateClicked.value && cancelTimer) {
      dateClicked.value = false;
      _timer!.cancel();
      return;
    }

    dateClicked.value = true;
    dateInfo.value = karnatakaHolidays[value] ??
        "Nothing for ${DateUtilsHelper.getTodayFormattedDateMD()} try some other date";
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(seconds: 3), () {
      dateClicked.value = false;
    });
  }

  void _parseOffDaysList() {
    karnatakaHolidays.clear();
    calendarMap.clear();

    for (final offDay in offDaysList) {
      final date = offDay.toDateTime();

      karnatakaHolidays[date] = offDay.event;
      calendarMap[date] =
          3; // 3 is your “holiday” color intensity or marker value
    }

    // Optionally add weekends
    calendarMap.addAll(generateWeekendData(2025, 1));
  }
}
