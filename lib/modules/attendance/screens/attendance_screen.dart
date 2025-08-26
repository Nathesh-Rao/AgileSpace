import 'package:axpert_space/modules/attendance/attendance.dart';
import 'package:axpert_space/modules/attendance/widgets/attendance_log_header_widget.dart';
import 'package:axpert_space/modules/attendance/widgets/attendance_log_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAttendanceLog();
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Attendance",
        ),
      ),
      body: Column(children: [
        AttendanceLogHeaderWidget(),
        Expanded(child: AttendanceLogWidget()),
      ]),
    );
  }
}
