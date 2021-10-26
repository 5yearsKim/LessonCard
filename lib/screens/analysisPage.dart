import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

//custom
import 'package:myapp/controller.dart';
import 'package:myapp/utils/misc.dart';
import 'package:myapp/tools/animatedButton.dart';
import 'package:myapp/utils/time.dart';

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
        child: Text('아직 연습 내역이 없어요.'),
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
              _portion = item['avgSec'] / maxVal['avgSec'];
              _label = secondsPrettify(item['avgSec']);
            } else if (metric == 'pracTime') {
              _portion = item['pracTime'] / maxVal['pracTime'];
              _label = secondsPrettify(item['pracTime']); 
            } else {
              // cnt
              _portion = item['cnt'] / maxVal['cnt'];
              _label = '총 ${item['cnt']}회'; 
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
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        AnimatedButton(
          label: 'total cnt',
          clicked: metric == 'cnt',
          onPressed: () {
            setMetric('cnt');
          },
        ),
        AnimatedButton(
          label: 'avgSec',
          clicked: metric == 'avgSec',
          onPressed: () {
            setMetric('avgSec');
          },
        ),
        AnimatedButton(
            label: 'pracTime',
            clicked: metric == 'pracTime',
            onPressed: () {
              setMetric('pracTime');
            })
      ]),
    );
  }
}

// class AnalysisContent extends StatelessWidget {
//   final Controller ctrl = Get.find();
//   late final keyOrder;
//   late final colorDict;
//   AnalysisContent() {
//     keyOrder = ctrl.report.keys.toList()
//       ..sort((a, b) {
//         int result = (ctrl.report[a]['cnt']).compareTo(ctrl.report[b]['cnt']);
//         return -result;
//       });

//     // color dict init
//     var tempDict = {};
//     ctrl.subjectName.forEach((item) {
//       tempDict[item['subject_name']] = item;
//     });
//     colorDict = tempDict;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (keyOrder.isEmpty) {
//       return Container(
//         child: Text('아직 연습 내역이 없어요.'),
//       );
//     }
//     return Column(
//       children: [
//         for (var k in keyOrder)
//           Container(
//               margin: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.0),
//                 color: Colors.amber[50],
//               ),
//               child: SubjectAnalysis(
//                 sbjName: k,
//                 maxCnt: ctrl.report[keyOrder[0]]['cnt'],
//                 color: colorDict[k]['color'],
//               )),
//       ],
//     );
//   }
// }

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
    return 20 + 200 * widget.portion;
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
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(widget.sbjName),
          )
        ),
        AnimatedContainer(
          width: _width,
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: widget._color,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          duration: Duration(milliseconds: 300),
          child: Text(widget.label, style: TextStyle(color: textOnColor(widget._color))),
        ),
      ]),
    );
  }
}
