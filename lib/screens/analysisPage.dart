import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//custom
import 'package:myapp/analController.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('analysis'),
      ),
      body: AnalysisContent(), 
    );
  }
}

class AnalysisContent extends StatefulWidget {
  final AnalController analCtrl = Get.find();
  AnalysisContent() {
    analCtrl.brintAllStamp();
  }

  @override
  _AnalysisContentState createState() => _AnalysisContentState();
}

class _AnalysisContentState extends State<AnalysisContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('hello'),
    );
  }
}