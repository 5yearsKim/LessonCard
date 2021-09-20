import 'package:flutter/material.dart';
// import 'tutorialPage.dart';
// import 'designPractice.dart';
import 'package:get/get.dart';
import 'screens/calendarPage.dart';
import 'screens/cardPage.dart';

import 'controller.dart';
import 'dbHelper.dart';

void main() => runApp(Nav2App());

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'practice project',
      theme: ThemeData(
        primarySwatch: Colors.amber,
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
        )
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ctrl = Get.put(Controller());
  final dbCtrl = Get.put(DBHelper());
  final Widget navigateCalendarButton = Container(
    child: TextButton(
      child: Text('caledar page'),
      onPressed: () => Get.toNamed('/calendar'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('navigation'),
        ),
        body: Column(
          children: [
            navigateCalendarButton,
          ],
        ));
  }
}
