import 'package:get/get.dart';

class CalendarController extends GetxController {
  var calendarViewSwitch = false.obs;

  switchCalendarView() {
    calendarViewSwitch.toggle();
  }
}
