import 'package:get/get.dart';
import 'dbHelper.dart';
import 'package:intl/intl.dart';

class Controller extends GetxController {
  final dbCtrl = Get.put(DBHelper());
  
  DateTime selectedDay = DateTime.now();
  Map<String, String> cardDict = {};

  void setSelectedDay(DateTime date) {
    selectedDay = date;
    update();
  }

  void bringCardList() async {
    final data = await dbCtrl.listCard() ?? [];
    cardDict = Map.fromIterable(data, key: (e) => e['target_date'], value: (e) => e['note']);
    print('card ${cardDict}');
    update();
  }

  Future<int> insertCard(String note) async {
    String formatDay = DateFormat('yyyy-MM-dd').format(selectedDay);
    int cid = await dbCtrl.insertCard(formatDay, note);
    bringCardList();
    return cid;
  }

  get todayCard {
    String formatDay = DateFormat('yyyy-MM-dd').format(selectedDay);
    return cardDict[formatDay];
  }
}
