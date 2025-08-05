import 'package:intl/intl.dart';

class StringUtils {
  static String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    return DateFormat('EEE, dd MMMM yyyy').format(date);
  }
}
