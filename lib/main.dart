import 'package:flutter/material.dart';
// import 'tutorialPage.dart';
// import 'designPractice.dart';
import 'package:get/get.dart';
import 'screens/calendarPage.dart';
import 'screens/cardPage.dart';
import 'screens/analysisPage.dart';

import 'controller.dart';
import 'dbHelper.dart';

void main() => runApp(Nav2App());

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'practice project',
      theme: ThemeData(
        primaryColor: Colors.amber[500],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
        ),
        scaffoldBackgroundColor: Colors.indigo[900],
      ),
      defaultTransition: Transition.native,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => MyHomePage(),
        ),
        GetPage(
          name: '/calendar',
          page: () => CalendarPage(),
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
      setState(() => isReady = true);
      ctrl.bringAllStamp();
      ctrl.bringSubjectName();
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
            title: Text('home'),
          ),
          body: CalendarPage(),
      ); 
    }
  }
}
