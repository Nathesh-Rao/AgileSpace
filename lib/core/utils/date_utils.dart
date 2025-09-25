import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String getDayName(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('EEEE').format(date);
    } catch (e) {
      return '';
    }
  }

  static String getTimeFromDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime date = DateTime.parse(dateStr);

      return DateFormat('h:mm a').format(date);
    } catch (e) {
      return '';
    }
  }

  static String getMonthName(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('MMMM').format(date);
    } catch (e) {
      return '';
    }
  }

  static String getShortDayName(String? dateStr) {
    if (dateStr == null) return "";

    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('EEE').format(date);
    } catch (e) {
      return '';
    }
  }

  static String getShortMonthName(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('MMM').format(date);
    } catch (e) {
      return '';
    }
  }

  static String getDateNumber(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd').format(date); // "20"
    } catch (e) {
      return '';
    }
  }

  static String getTodayFormattedDate({DateTime? date}) {
    return DateFormat("MMM d, y").format(date ?? DateTime.now());
  }

  static String getTodayFormattedDateMD({DateTime? date}) {
    return DateFormat("MMM d").format(date ?? DateTime.now());
  }

  static String getFormattedDateYMD(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('yyyy/MM/dd').format(date);
    } catch (e) {
      return '';
    }
  }
}
