// import 'package:flutter/cupertino.dart';

import 'package:axpert_space/common/common.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarMonthViewWidget extends StatefulWidget {
  const CalendarMonthViewWidget({super.key});

  @override
  State<CalendarMonthViewWidget> createState() =>
      _CalendarMonthViewWidgetState();
}

class _CalendarMonthViewWidgetState extends State<CalendarMonthViewWidget> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Calendar Month View
        SfCalendar(
          view: CalendarView.month,
          headerDateFormat: 'MMMM',
          todayHighlightColor: Colors.purple,
          selectionDecoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.purple, width: 2),
          ),
          onSelectionChanged: (calendarSelectionDetails) {
            setState(() {
              _selectedDate = calendarSelectionDetails.date ?? DateTime.now();
            });
          },
          monthViewSettings: const MonthViewSettings(
            showAgenda: false,
            appointmentDisplayMode: MonthAppointmentDisplayMode.none,
          ),
        ),

        const SizedBox(height: 16),

        /// Example event list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Today", Icons.calendar_today),
              _buildEvent("Daily Standup", "08:00", Colors.green),
              _buildEvent("Budget Review", "09:00", Colors.red),
              _buildEvent("Sasha Jay 121", "10:00", Colors.orange),
              _buildEvent("Web Team Progress Update", "11:00", Colors.teal),
              _buildEvent("Social team briefing", "12:00", Colors.teal),
              const SizedBox(height: 12),
              _buildSectionTitle("Tomorrow", Icons.calendar_today),
              _buildEvent("Daily Standup", "13:00", Colors.green),
              _buildEvent("Tech Standup", "14:00", Colors.purple),
              _buildEvent("Developer Progress", "15:00", Colors.blue),
              const SizedBox(height: 12),
              _buildSectionTitle("Attention required", Icons.flight_takeoff),
              _buildEvent("Bahamas", "01-02 to 14-02", Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 18),
          8.verticalSpace,
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvent(String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
