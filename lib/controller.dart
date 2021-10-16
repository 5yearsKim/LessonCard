import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dbHelper.dart';
import 'package:intl/intl.dart';

class Controller extends GetxController {
  final dbCtrl = Get.put(DBHelper());

  DateTime selectedDay = DateTime.now();
  Map<String, dynamic> cardDict = {};
  List<dynamic> trackList = [];
  Map<int, List<dynamic>> stampDict = {};
  List<dynamic> subjectName = [];

  get formatDay {
    return DateFormat('yyyy-MM-dd').format(selectedDay);
  }

  get todayCard {
    return cardDict[formatDay];
  }

  void setSelectedDay(DateTime date) {
    selectedDay = date;
    update();
  }

  // card
  Future<void> bringCardList() async {
    final data = await dbCtrl.listCard() ?? [];
    cardDict = Map.fromIterable(data, key: (e) => e['target_date'], value: (e) => e);
    // print('card ${cardDict}');
    update();
  }

  Future<int> insertCard(String note) async {
    int cid = await dbCtrl.insertCard(formatDay, note);
    await bringCardList();
    update();
    return cid;
  }

  Future<void> updateCard({String? note}) async {
    if (note == null) 
      return ;
    await dbCtrl.updateCard(formatDay, note: note);
    bringCardList();
    // update();
  }

  // track
  Future<void> bringTrackList() async {
    trackList = await dbCtrl.listTrack(formatDay);
    update();
  }

  Future<int> insertTrack(String subjectName, {String stampName = '', int maxStamp = 7, String color = ''}) async {
    int tid = await dbCtrl.insertTrack(formatDay, subjectName, stampName, maxStamp, trackList.length, color);
    bringTrackList();
    update();
    return tid;
  }

  Future<int> deleteTrack(int track_id) async {
    int tid = await dbCtrl.deleteTrack(track_id);
    bringTrackList();
    update();
    return tid;
  }


  void reorderTrack(int oldIdx, int newIdx) {
    if (oldIdx > trackList.length || newIdx > trackList.length) {
      // print('track length: ${trackList.length}/${oldIdx} ${newIdx}');
      return;
    }
    // print('${oldIdx} ${newIdx}');
    if (oldIdx < newIdx) {
      newIdx -= 1;
    }
    var newList = List.from(trackList);
    final item = newList.removeAt(oldIdx);
    newList.insert(newIdx, item);

    trackList = newList;
    saveOrder();
    update();
  }

  Future<void> bringSubjectName() async {
    final data = await dbCtrl.listSubjectName();
    subjectName = data;
    update();
  }

  void saveOrder() {
    dynamic item;
    for (int i = 0; i < trackList.length; i++) {
      item = trackList[i];
      // print(item);
      if (i != item['order_idx']) {
        // print('${item['subject_name']}: ${item['order_idx']} => ${i}');
        updateTrack(item['id'], orderIdx: i);
      }
    }
  }

  Future<void> updateTrack(int trackId, {String? subjectName, int? maxStamp, int? orderIdx, Color? color, String? stampName}) async {
    await dbCtrl.updateTrack(
      trackId,
      subjectName: subjectName,
      maxStamp: maxStamp,
      orderIdx: orderIdx,
      color: color?.value.toString(),
      stampName: stampName,
    );
    bringTrackList();
    // update(); 
  }

  //stamp 
  void bringStampList() async {
    final data = await dbCtrl.listStamp(formatDay) ?? [];
    var item;
    Map<int, List<dynamic>> tempDict = {};
    for (int i=0; i < data.length; i++ ) {
      item = data[i];
      if (tempDict.containsKey(item['track_id'])) {
        tempDict[item['track_id']]?.add(item);
      } else {
        tempDict[item['track_id']] = [item];
      }
    }
    stampDict = tempDict;
    update();
  }

  void bringStampByTrackId(trackId) async {
    final data = await dbCtrl.listStampByTrack(trackId);
    stampDict[trackId] = data;
    update();
  }

  Future<int> insertStamp(trackId, [note='']) async {
    int sid = await dbCtrl.insertStamp(trackId, note);
    bringStampByTrackId(trackId);
    update();
    return sid;
  }

  Future<int> deleteStamp(trackId, stampId) async {
    int sid = await dbCtrl.deleteStamp(stampId);
    bringStampByTrackId(trackId);
    update();
    return sid;
  }

  Future<void> updateStamp(trackId, stampId, {String? note}) async {
    await dbCtrl.updateStamp(stampId, note: note);
    bringStampByTrackId(trackId);
    update();
  }
}
