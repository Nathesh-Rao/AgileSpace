import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/active_list/widgets/active_list_floating_button_widget.dart';
import 'package:axpert_space/modules/active_list/widgets/active_list_header_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../active_list/widgets/active_list_progress_widget.dart';
import '../../../active_list/widgets/active_list_task_list_widget.dart';

class LandingActiveTaskTab extends StatelessWidget {
  const LandingActiveTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            5.verticalSpace,
            Text(
              "Stay Active & Organized ✅",
              style: AppStyles.appBarTitleTextStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryActionColorDarkBlue,
                fontSize: 16.sp,
              ),
            ),
            3.verticalSpace,
            Text(
              "Tasks - Progress - Deadlines",
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          ActiveListHeaderWidget(),
          ActiveListProgressWidget(),
          ActiveListTaskListWidget(),
        ],
      )),
      floatingActionButton: ActiveListFloatingButtonWidget(),
    );
  }
}
