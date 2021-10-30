import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

// custom
import 'package:lessonCard/config.dart';
import 'package:lessonCard/controller.dart';
import 'package:lessonCard/tools/numericStepButton.dart';
import 'package:lessonCard/tools/animalPicker.dart';
import 'package:lessonCard/utils/stamp.dart';
import 'package:lessonCard/utils/misc.dart';

// Track Button
class TrackButton extends StatefulWidget {
  final int i;
  const TrackButton(int this.i, {Key? key}) : super(key: key);

  @override
  _TrackButtonState createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  final Controller ctrl = Get.find();
  get track {
    return ctrl.trackList[widget.i];
  }

  get trackColor {
    return code2color(track['color']);
  }

  get textColor {
    return textOnColor(trackColor);
  }

  void openEditPage(BuildContext context) async {
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
                child: EditTrack(widget.i),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<Controller>(
        builder: (_) => Container(
          alignment: Alignment.center,
          width: 90,
          child: ElevatedButton(
            onPressed: () {
              openEditPage(context);
            },
            style: ElevatedButton.styleFrom(
              primary: trackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            child: Text(
              track['subject_name'],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

// EditTrack
class EditTrack extends StatefulWidget {
  final int i;
  const EditTrack(int this.i, {Key? key}) : super(key: key);

  @override
  _EditTrackState createState() => _EditTrackState();
}

class _EditTrackState extends State<EditTrack> {
  final Controller ctrl = Get.find();
  TextEditingController nameTcr = TextEditingController();
  late Color _color;
  int maxStamp = 7;
  String stampName = 'cat';

  get track {
    return ctrl.trackList[widget.i];
  }

  @override
  void initState() {
    super.initState();
    nameTcr.text = track['subject_name'];
    maxStamp = track['max_stamp'];
    stampName = track['stamp_name'];
    _color = code2color(track['color']);
  }

  void _openDialog(String title, Widget content, List<Widget> actions) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: content,
          actions: actions,
        );
      },
    );
  }

  void openAnimlPicker(BuildContext context) async {
    _openDialog(
        '테마 도장',
        AnimalPicker(
          animal: stampName,
          onChangeAnimal: (animal) {
            setState(() {
              stampName = animal;
            });
          },
        ),
        [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);
  }

  void openColorPicker(BuildContext context) async {
    _openDialog(
        '테마 컬러',
        MaterialColorPicker(
          onColorChange: (Color color) {
            setState(() => _color = color);
            // Navigator.of(context).pop();
          },
          selectedColor: Colors.blue,
        ),
        [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ]);
  }

  void openDeleteConfirm(BuildContext context, onDismiss) async {
    _openDialog('정말 삭제하시겠습니까?', Text('삭제하시면 기록들이 다 사라집니다.'), [
      TextButton(
        onPressed: () {
          onDismiss();
          Navigator.of(context).pop();
          ctrl.deleteTrack(track['id']);
        },
        child: Text('삭제'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    const lw = 4;
    const rw = 6;
    return Column(mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: lw,
                child: Center(
                  child: Text(
                    'trackName'.tr,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Expanded(
                flex: rw,
                child: TextField(
                  maxLength: MAX_TRACKNAME_LEN,
                  textAlign: TextAlign.center,
                  controller: nameTcr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: lw,
                child: Center(
                  child: Text(
                    'themeColor'.tr,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Expanded(
                flex: rw,
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.circle),
                    iconSize: 25,
                    color: _color,
                    tooltip: 'msgSelectColor'.tr,
                    onPressed: () {
                      openColorPicker(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: lw,
                child: Center(
                  child: Text(
                    'maxStamp'.tr,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Expanded(
                flex: rw,
                child: NumericStepButton(
                    minValue: 0,
                    maxValue: 10,
                    initValue: maxStamp,
                    onChanged: (value) {
                      setState(() => maxStamp = value);
                    }),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: lw,
                child: Center(
                  child: Text(
                    'themeStamp'.tr,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Expanded(
                flex: rw,
                child: IconButton(
                  icon: Image.asset(animalDict[stampName] ?? (animalDict['bear'] as String)),
                  onPressed: () {
                    openAnimlPicker(context);
                  },
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.delete),
                onPressed: () {
                  openDeleteConfirm(context, () => Navigator.of(context).pop());
                },
                label: Text(
                  'delete'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // submit button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  onPrimary: Colors.white,
                  shape: StadiumBorder(),
                ),
                onPressed: () async {
                  await ctrl.updateTrack(
                    track['id'],
                    subjectName: nameTcr.text,
                    color: _color,
                    maxStamp: maxStamp,
                    stampName: stampName,
                  );
                  Navigator.of(context).pop();
                },
                child: Text('save'.tr),
              ),
            ],
          )
        ]);
  }
}
