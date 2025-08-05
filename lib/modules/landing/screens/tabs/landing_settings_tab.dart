import 'package:flutter/material.dart';

class LandingSettingsTab extends StatelessWidget {
  const LandingSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Settings"),
      ),
    );
  }
}
