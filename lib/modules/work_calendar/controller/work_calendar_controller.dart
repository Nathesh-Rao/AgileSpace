import 'dart:async';

import 'package:axpert_space/core/utils/date_utils.dart';
import 'package:get/get.dart';

class WorkCalendarController extends GetxController {
  var dateClicked = false.obs;
  var dateInfo = ''.obs;
  Timer? _timer;

  DateTime selectedDate = DateTime.now();

  Map<DateTime, int> calendarMap = {
    DateTime(2025, 1, 1): 3,
    DateTime(2025, 1, 14): 3,
    DateTime(2025, 2, 26): 3,
    DateTime(2025, 4, 14): 3,
    DateTime(2025, 5, 1): 3,
    DateTime(2025, 8, 15): 3,
    DateTime(2025, 8, 27): 3,
    DateTime(2025, 10, 1): 3,
    DateTime(2025, 10, 2): 3,
    DateTime(2025, 10, 20): 3,
    DateTime(2025, 1, 26): 3,
    DateTime(2025, 3, 30): 3,
    DateTime(2025, 6, 7): 3,
    DateTime(2025, 7, 6): 3,
    DateTime(2025, 11, 1): 3,
    ...generateWeekendData(2025, 1),
  };

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

  final Map<DateTime, String> karnatakaHolidays = {
    DateTime(2025, 1, 1): "New Year",
    DateTime(2025, 1, 14):
        "Uttarayana / Punya Kala / Makara Sankranti Festival",
    DateTime(2025, 2, 26): "Maha Shivaratri",
    DateTime(2025, 4, 14): "New Year for Tamil and Malayalam",
    DateTime(2025, 5, 1): "Labour Day",
    DateTime(2025, 8, 15): "Independence Day",
    DateTime(2025, 8, 27): "Varasiddhi Vinayaka Vratha / Ganesh Chaturthi",
    DateTime(2025, 10, 1): "Maha Navami / Ayudh Pooja",
    DateTime(2025, 10, 2): "Mahatma Gandhi’s Birthday / Vijayadashami",
    DateTime(2025, 10, 20): "Deepavali",
    DateTime(2025, 1, 26): "Republic Day (National Day)",
    DateTime(2025, 3, 30): "Ugadi Festival",
    DateTime(2025, 6, 7): "Bakrid (Feast of Sacrifice)",
    DateTime(2025, 7, 6): "Muharram",
    DateTime(2025, 11, 1): "Kannada Rajyothsava",
  };

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
}
