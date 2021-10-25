import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

//custom
import 'package:myapp/controller.dart';
import 'package:myapp/utils/misc.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('analysis'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: AnalysisContent(),
        ),
      ),
    );
  }
}

class AnalysisContent extends StatelessWidget {
  final Controller ctrl = Get.find();
  late final keyOrder;
  late final colorDict;
  AnalysisContent() {
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
    if (keyOrder.isEmpty) {
      return Container(
        child: Text('아직 연습 내역이 없어요.'),
      );
    }
    return Column(
      children: [
        for (var k in keyOrder)
          Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.amber[50],
              ),
              child: SubjectAnalysis(
                sbjName: k,
                maxCnt: ctrl.report[keyOrder[0]]['cnt'],
                color: colorDict[k]['color'],
              )),
      ],
    );
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
    _color = code2color(color);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Text('$sbjName', style: TextStyle(color: _color)),
        ),
        Flexible(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  width: 30.0 + (item['cnt'] / maxCnt) * 200,
                  padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('총 ${item['cnt']}번', 
                    style: TextStyle(
                      color: Colors.white,
                    )
                  ),
                ),
                Text('한곡 평균 길이: ${item['avgSec']}초'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
