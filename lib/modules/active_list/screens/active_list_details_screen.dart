import 'package:axpert_space/common/common.dart';
import 'package:axpert_space/modules/active_list/widgets/active_list_details/active_list_details_bottom_bar_widget.dart';
import 'package:axpert_space/modules/active_list/widgets/active_list_details/active_list_details_floating_action_widget.dart';
import 'package:axpert_space/modules/active_list/widgets/active_list_details/active_list_details_header_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/active_list_details/active_list_detail_appbar_widget.dart';
import '../widgets/active_list_details/active_list_details_body_widget.dart';

class ActiveListDetailsScreen extends StatelessWidget {
  const ActiveListDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActiveListDetailAppbarWidget(),
      body: Column(
        children: [
          ActiveListDetailsHeaderWidget(),
          ActiveListDetailsBodyWidget(),
        ],
      ),
      bottomNavigationBar: ActiveListDetailsBottomBarWidget(),
      floatingActionButton: ActiveListDetailsFloatingActionWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
