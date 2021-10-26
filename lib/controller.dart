import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dbHelper.dart';
import 'package:intl/intl.dart';
import 'dart:math';

typedef ReportDict = Map<String, Map<int, List<dynamic>>>;

class Controller extends GetxController {
  final dbCtrl = Get.put(DBHelper());

  DateTime selectedDay = DateTime.now();
  Map<String, dynamic> cardDict = {};
  List<dynamic> trackList = [];
  Map<int, List<dynamic>> stampDict = {};
  List<dynamic> subjectName = [];

  ReportDict reportDict = {};
  
  get report {
    var ret = {};
    for (String sbjName  in reportDict.keys) {
      var anal = analyzer(reportDict[sbjName]!);
      ret[sbjName] = anal;
    }
    return ret;
  }

  get reportMax{
    int maxCnt = 0;
    double maxAvgSec = 0;
    double maxPracTime = 0;

    for (var v in report.values) {
      print('hh');
      print(v);
      if (v['cnt'] != null) 
        maxCnt = max(v['cnt'], maxCnt);
      if (v['avgSec'] != null)
        maxAvgSec = max(v['avgSec'], maxAvgSec);
      if (v['pracTime'] != null)
        maxPracTime = max(v['pracTime'], maxPracTime);
        print(v['pracTime']);
    }
    if (maxAvgSec == 0)
      maxAvgSec = double.infinity;
    if (maxPracTime == 0) 
      maxPracTime = double.infinity;
    return {'cnt': maxCnt, 'avgSec': maxAvgSec, 'pracTime': maxPracTime};
  }

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


  bringAllStamp() async {
    final data = await dbCtrl.listStampAll();
    ReportDict temp = {};
    for (var item in data) {
      String sbjName = item['subject_name'];
      int trackId = item['track_id'];
      if (temp.containsKey(sbjName)) {
        if (temp[sbjName]!.containsKey(trackId)) {
          temp[sbjName]![trackId]!.add(item);
        } else {
          temp[sbjName]![trackId] = [item];
        }
        temp[sbjName];
      } else {
        temp[sbjName] = {
          trackId: [item]
        };
      }
    }
    reportDict = temp;
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


dynamic analyzer(Map<int, List<dynamic>> dict) {
  List<dynamic> timeDiffList = [];
  int cnt = 0;
  double? avgSec = null;
  double? totalPrac = null;
  for (var trackId in dict.keys) {
    cnt += dict[trackId]!.length;
    List<dynamic> itemList = dict[trackId]!;
    itemList.sort((a, b) => a['created_at'].compareTo(b['created_at']));
    for (int i = 0 ; i < itemList.length - 1; i++ ) {
      var thisStamp = DateTime.parse(itemList[i]['created_at']);
      // print(itemList[i]['created_at']);
      var nextStamp = DateTime.parse(itemList[i + 1]['created_at']);
      var diff = nextStamp.difference(thisStamp).inSeconds;
      timeDiffList.add(diff);
    }
  }
  timeDiffList = timeDiffList.where((item) => item < 3600).toList();
  timeDiffList.sort();
  if (timeDiffList.length > 3) {
    final len = timeDiffList.length;
    final startp = len ~/ 3;
    final endp = 2 * len ~/ 3;
    num sum = 0;
    for (var i = startp; i <= endp; i ++) {
      sum += timeDiffList[i];
    }
    avgSec = sum / (endp - startp + 1);
  } else if (timeDiffList.length > 0){
    num sum = timeDiffList.reduce((a, b) => a + b);
    avgSec = sum / timeDiffList.length;
  }
  totalPrac = avgSec == null ? null : avgSec * cnt ;
  // print(timeDiffList);
  return {'cnt': cnt, 'avgSec': avgSec, 'pracTime': totalPrac };
}

