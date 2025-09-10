import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarTaskViewWidget extends StatefulWidget {
  const CalendarTaskViewWidget({super.key});

  @override
  _CalendarTaskViewWidgetState createState() => _CalendarTaskViewWidgetState();
}

class _CalendarTaskViewWidgetState extends State<CalendarTaskViewWidget> {
  late MeetingDataSource _events;

  @override
  void initState() {
    super.initState();
    _events = MeetingDataSource(_getDataSource());
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
        view: CalendarView.week, // 👈 Week view
        timeSlotViewSettings: TimeSlotViewSettings(
          timeInterval: const Duration(hours: 1),
          timeFormat: "h:mm a",
        ),
        dataSource: _events);
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();

    meetings.add(Meeting(
      'Weekly meetup',
      'Make a landing page and mobile',
      today.add(Duration(hours: 8)),
      today.add(Duration(hours: 9)),
      Colors.blue,
      false,
    ));

    meetings.add(Meeting(
      'Ticket - ID123879',
      'Assigned to Srijesh',
      today.add(Duration(hours: 9)),
      today.add(Duration(hours: 10)),
      Colors.indigo,
      false,
    ));

    meetings.add(Meeting(
      'Task - ID99999',
      'Assigned to Narasimha',
      today.add(Duration(hours: 12)),
      today.add(Duration(hours: 13)),
      Colors.red,
      false,
    ));

    return meetings;
  }
}

/// Model
class Meeting {
  Meeting(this.eventName, this.description, this.from, this.to, this.background,
      this.isAllDay);

  String eventName;
  String description;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

/// DataSource for calendar
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].from;
  @override
  DateTime getEndTime(int index) => appointments![index].to;
  @override
  String getSubject(int index) => appointments![index].eventName;
  @override
  Color getColor(int index) => appointments![index].background;
  @override
  bool isAllDay(int index) => appointments![index].isAllDay;
}
