import 'package:flutter/material.dart';
// import 'tutorialPage.dart';
// import 'designPractice.dart';
import 'calendarPage.dart';
import 'package:get/get.dart';

void main() => runApp(Nav2App());

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'practice project',
      theme: ThemeData(
        primarySwatch: Colors.amber,
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
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
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
