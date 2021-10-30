import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

//custom
import 'package:lessonCard/config.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('setting'.tr, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Settings(),
        ));
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void openLangSelect(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: EdgeInsets.all(30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: SelectLang(),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          child: Text('language'.tr,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  )),
          onPressed: () {
            openLangSelect(context);
          },
        ),
      ],
    );
  }
}

class SelectLang extends StatefulWidget {
  const SelectLang({Key? key}) : super(key: key);

  @override
  _SelectLangState createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  Locale? tmpLocale = Get.locale;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('한국어'),
          leading: Radio(
            value: Locale('ko', 'KR'),
            groupValue: tmpLocale,
            activeColor: primaryColor,
            onChanged: (Locale? val) {
              setState(() => tmpLocale = val);
            },
          ),
        ),
        ListTile(
          title: Text('English'),
          leading: Radio(
            value: Locale('en', 'EN'),
            groupValue: tmpLocale,
            activeColor: primaryColor,
            onChanged: (Locale? val) {
              setState(() => tmpLocale = val);
            },
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                onPrimary: Colors.white,
              ),
              onPressed: () {
                if (tmpLocale != null) {
                  Get.updateLocale(tmpLocale!);
                  box.write('locale', tmpLocale.toString());
                }
                Navigator.of(context).pop();
              },
              child: Text('save'.tr),
            ),
          ],
        )
      ],
    );
  }
}
