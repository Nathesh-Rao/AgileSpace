import 'package:flutter/material.dart';

class LandingCalendarTab extends StatelessWidget {
  const LandingCalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Calendar"),
      ),
    );
  }
}
