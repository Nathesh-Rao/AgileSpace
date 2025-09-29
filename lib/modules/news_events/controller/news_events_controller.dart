import 'package:axpert_space/modules/news_events/models/announcement_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsEventsController extends GetxController {
  var pageController = PageController();
  RxInt currentIndex = 0.obs;

  var announcementList = AnnouncementModel.tempData();
}
