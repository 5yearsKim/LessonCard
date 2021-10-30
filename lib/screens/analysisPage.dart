import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

//custom
import 'package:lessonCard/config.dart';
import 'package:lessonCard/controller.dart';
import 'package:lessonCard/utils/misc.dart';
import 'package:lessonCard/tools/animatedButton.dart';
import 'package:lessonCard/utils/time.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dataAnalysis'.tr, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: AnalysisContent(),
        ),
      ),
    );
  }
}

class AnalysisContent extends StatefulWidget {
  const AnalysisContent({Key? key}) : super(key: key);

  @override
  _AnalysisContentState createState() => _AnalysisContentState();
}

class _AnalysisContentState extends State<AnalysisContent> {
  String metric = 'cnt';
  final Controller ctrl = Get.find();
  late final keyOrder;
  late final colorDict;
  late final maxVal;

  @override
  initState() {
    super.initState();
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
    maxVal = ctrl.reportMax;
  }

  @override
  Widget build(BuildContext context) {
    if (keyOrder.isEmpty) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Text('msgNoData'.tr,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.grey[600],
                )),
      );
    }
    return Column(
      children: [
        SelectMetric(
          setMetric: (text) {
            setState(() => metric = text);
          },
          metric: metric,
        ),
        for (var k in keyOrder)
          Builder(builder: (BuildContext context) {
            final item = ctrl.report[k];
            double _portion = 0;
            String _label = '';
            if (metric == 'avgSec') {
              if (item['avgSec'] == null) {
                _portion = 0;
                _label = 'unmeasurable'.tr;
              } else {
                _portion = item['avgSec'] / maxVal['avgSec'];
                _label = secondsPrettify(item['avgSec']);
              }
            } else if (metric == 'pracTime') {
              if (item['pracTime'] == null) {
                _portion = 0;
                _label = 'unmeasurable'.tr;
              } else {
                _portion = item['pracTime'] / maxVal['pracTime'];
                _label = secondsPrettify(item['pracTime']);
              }
            } else {
              // cnt
              _portion = item['cnt'] / maxVal['cnt'];
              // _label = '총 ${item['cnt']}회';
              _label = 'totalCntN'.trParams({
                'N': item['cnt'].toString(),
              });
            }
            return SubjectAnalysis(
              sbjName: k,
              label: _label,
              portion: _portion,
              color: colorDict[k]['color'],
            );
          }),
      ],
    );
  }
}

class SelectMetric extends StatelessWidget {
  final ValueSetter setMetric;
  final String metric;

  SelectMetric({required this.setMetric, required this.metric});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        AnimatedButton(
          label: 'totalCnt'.tr,
          clicked: metric == 'cnt',
          onPressed: () {
            setMetric('cnt');
          },
        ),
        AnimatedButton(
          label: 'songLength'.tr,
          clicked: metric == 'avgSec',
          onPressed: () {
            setMetric('avgSec');
          },
        ),
        AnimatedButton(
            label: 'practiceTime'.tr,
            clicked: metric == 'pracTime',
            onPressed: () {
              setMetric('pracTime');
            })
      ]),
    );
  }
}

class SubjectAnalysis extends StatefulWidget {
  final String sbjName;
  final String label;
  final double portion;
  late final _color;

  SubjectAnalysis({this.sbjName: '', this.label: '', this.portion: 0, color}) {
    _color = code2color(color);
  }

  @override
  _SubjectAnalysisState createState() => _SubjectAnalysisState();
}

class _SubjectAnalysisState extends State<SubjectAnalysis> {
  @override
  initState() {
    super.initState();
  }

  get _width {
    if (widget.portion == 0) {
      return 100.0;
    }
    return 30 + widget.portion * (MediaQuery.of(context).size.width - 100);
  }

  get _color {
    return widget.portion == 0.0 ? Colors.grey : widget._color;
  }

  get lightColor {
    return lightenColor(widget._color, amount: 0.4);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[100],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: widget._color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: lightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                widget.sbjName,
                style: TextStyle(
                  color: textOnColor(lightColor),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        AnimatedContainer(
          width: _width,
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          duration: Duration(milliseconds: 300),
          child: Text(widget.label, style: TextStyle(color: textOnColor(_color))),
        ),
      ]),
    );
  }
}
