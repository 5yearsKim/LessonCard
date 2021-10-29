import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:get/get.dart';
import 'screens/calendarPage.dart';
import 'screens/cardPage.dart';
import 'screens/analysisPage.dart';

import 'controller.dart';
import 'dbHelper.dart';
import 'config.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(Nav2App()));
}

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'practice project',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
        ).copyWith(
          secondary: secondaryColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
      ),
      defaultTransition: Transition.native,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => MyHomePage(),
        ),
        GetPage(
          name: '/card',
          page: () => CardPage(),
        ),
        GetPage(
          name: '/analysis',
          page: () => AnalysisPage(),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final dbCtrl;
  late final ctrl;
  var isReady = false;

  @override
  void initState() {
    super.initState();
    dbCtrl = Get.put(DBHelper());
    ctrl = Get.put(Controller());

    _asyncMethod() async {
      await dbCtrl.initDb();
      ctrl.bringAllStamp();
      ctrl.bringSubjectName();
      setState(() => isReady = true);
    }
    _asyncMethod();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Scaffold(
        body: Text('loading..')
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('스케줄',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold)
            ),
          ),
          body: CalendarPage(),
      ); 
    }
  }
}
