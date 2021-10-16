import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dbHelper.dart';
import 'package:intl/intl.dart';

class AnalController extends GetxController {
  final dbCtrl = Get.put(DBHelper());

  brintAllStamp() async {
    final data = await dbCtrl.listStampAll();
    print(data);
  }
  
}

