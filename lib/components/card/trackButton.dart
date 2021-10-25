import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

// custom
import 'package:myapp/controller.dart';
import 'package:myapp/tools/numericStepButton.dart';
import 'package:myapp/tools/animalPicker.dart';
import 'package:myapp/utils/stamp.dart';
import 'package:myapp/utils/misc.dart';


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
    return trackColor.computeLuminance() >= 0.7 ? Colors.black.withOpacity(0.7) : Colors.white;
  }

  void openEditPage(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: EditTrack(widget.i),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GetBuilder<Controller>(
            builder: (_) => ElevatedButton(
                  onPressed: () {
                    openEditPage(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: trackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )
                  ),
                  child: Text(track['subject_name'],
                    style: TextStyle(color: textColor),
                  ),
                )));
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
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: actions,
        );
      },
    );
  }

  void openAnimlPicker(BuildContext context) async {
    _openDialog(
        'Animal Picker',
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
        'color picker',
        MaterialColorPicker(
          onColorChange: (Color color) {
            print(color);
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
            child: Text('submit'),
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
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('트랙 이름:'),
            Expanded(
              child: TextField(
                controller: nameTcr,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('테마 컬러: '),
            Container(
              child: IconButton(
                icon: Icon(Icons.circle),
                iconSize: 15,
                color: _color,
                tooltip: '컬러를 선택해주세요!',
                onPressed: () {
                  openColorPicker(context);
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('도장 개수'),
            NumericStepButton(
                minValue: 0,
                maxValue: 10,
                initValue: maxStamp,
                onChanged: (value) {
                  setState(() {
                    maxStamp = value;
                  });
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('도장 모양'),
            IconButton(
              icon: Image.asset(animalDict[stampName] ?? (animalDict['bear'] as String)),
              onPressed: () {
                openAnimlPicker(context);
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                openDeleteConfirm(context, () => Navigator.of(context).pop());
              },
              child: Text('삭제하기'),
            ),
          ],
        ),
        // submit button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
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
              child: Text('수정하기'),
            ),
          ],
        )
      ]),
    );
  }
}
