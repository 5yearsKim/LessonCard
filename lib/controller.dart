import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  DateTime selectedDay = DateTime.now();

  void setSelectedDay(DateTime date) {
    selectedDay = date;
    update();
  }
}
