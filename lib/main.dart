import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/calendarPage.dart';
import 'screens/cardPage.dart';
import 'screens/analysisPage.dart';
import 'screens/settingPage.dart';

import 'controller.dart';
import 'dbHelper.dart';
import 'messages.dart';
import 'config.dart';

void main() async {
  await initializeDateFormatting();
  await GetStorage.init();
  runApp(Nav2App());
}

class Nav2App extends StatelessWidget {
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final String? tmpLocale = box.read('locale');
    Locale? myLocale;
    if (tmpLocale != null) {
      var parsed = tmpLocale.split('_');
      myLocale = Locale(parsed[0], parsed[1]);
    }
    print(myLocale);

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
      translations: Messages(),
      locale: myLocale ?? Get.deviceLocale,
      // locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
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
        GetPage(
          name: '/settings',
          page: () => SettingPage(),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
      return Scaffold(body: Text('loading..'));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('schedule'.tr, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: secondaryColor),
              tooltip: 'settings',
              onPressed: () {
                Get.toNamed('/settings');
              },
            ),
          ],
        ),
        body: CalendarPage(),
      );
    }
  }
}
