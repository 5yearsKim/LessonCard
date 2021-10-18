import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//custom
import 'package:myapp/controller.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('analysis'),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: AnalysisContent(),
      ),
    );
  }
}

class AnalysisContent extends StatelessWidget {
  final Controller ctrl = Get.find();
  late final keyOrder;
  late final colorDict;
  AnalysisContent() {
    ctrl.bringAllStamp();
    ctrl.bringSubjectName();

    keyOrder = ctrl.report.keys.toList()
      ..sort((a, b) {
        int result = (ctrl.report[a]['cnt']).compareTo(ctrl.report[b]['cnt']);
        return -result;
      });

    // color dict init
    var tempDict = {};
    ctrl.subjectName.forEach((item) {
      tempDict[item['subject_name']] = item;
    });
    colorDict = tempDict;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(builder: (_) {
      return Column(
        children: [
          for (var k in keyOrder)
            Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                ),
                child: SubjectAnalysis(
                  sbjName: k,
                  maxCnt: ctrl.report[keyOrder[0]]['cnt'],
                  color: colorDict[k]['color'],
                )),
        ],
      );
    });
  }
}

class SubjectAnalysis extends StatelessWidget {
  final Controller ctrl = Get.find();
  final sbjName;
  final maxCnt;
  final color;
  late final item;
  late final _color;
  SubjectAnalysis({this.sbjName, this.maxCnt, this.color}) {
    item = ctrl.report[sbjName];
    try {
      _color = Color(int.parse(color));
    } catch (e) {
      _color = Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Text('$sbjName', style: TextStyle(color: _color)),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: (item['cnt'] / maxCnt) * 200,
                height: 30,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Text('practice count ${item['cnt']}'),
              Text('average practice time per song = ${item['avgSec']}'),
            ],
          ),
        )
      ],
    );
  }
}
