import 'package:flutter/material.dart';

class LandingPayAndAttendanceTab extends StatelessWidget {
  const LandingPayAndAttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Pay and Attendance"),
      ),
    );
  }
}
