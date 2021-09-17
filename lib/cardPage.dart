import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'trackLine.dart';
import 'controller.dart';
import 'tools/numericStepButton.dart';
import 'utils/stamp.dart';

class CardPage extends StatelessWidget {
  CardPage({Key? key}) : super(key: key);
  final Controller ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('card page'),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TrackList(),
                AddTrack(),
              ],
            ),
          ),
        ));
  }
}

class TrackList extends StatelessWidget {
  TrackList() {
    ctrl.bringTrackList();
    ctrl.bringStampList();
  }

  final Controller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    // return Container(
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 500,
          child: GetBuilder<Controller>(
              builder: (_) => ReorderableListView(
                    shrinkWrap: true,
                    children: [
                      for (int i = 0; i < ctrl.trackList.length; i++)
                        Row(
                          key: Key('${i}'),
                          children: [
                            TrackButton(i),
                            TrackLine(
                              trackId: ctrl.trackList[i]['id'],
                              maxStamp: ctrl.trackList[i]['max_stamp'],
                              stampName: ctrl.trackList[i]['stamp_name'] ?? 'bear',
                              // maxStamp: 3,
                            )
                          ],
                        ),
                    ],
                    padding: EdgeInsets.all(10),
                    onReorder: (int oldIdx, int newIdx) {
                      ctrl.reorderTrack(oldIdx, newIdx);
                    },
                  )),
        ));
  }
}

class TrackButton extends StatefulWidget {
  final int i;
  const TrackButton(int this.i, {Key? key}) : super(key: key);

  @override
  _TrackButtonState createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  final Controller ctrl = Get.find();
  TextEditingController nameTcr = TextEditingController();
  late Color _color;
  late int maxStamp;
  String stampName = 'cat';

  get track {
    return ctrl.trackList[widget.i];
  }

  @override
  void initState() {
    super.initState();
    nameTcr.text = track['subject_name'];
    maxStamp = track['max_stamp'];
    try {
      print(track['color']);
      _color = Color(int.parse(track['color']));
    } catch (e) {
      print(e);
      _color = Colors.blue;
    }
  }

  void _openDialog(String title, Widget content, List<Widget> actions) {
    print(maxStamp);
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
            onPressed: () {},
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

  void openEditPage(BuildContext context) async {
    _openDialog(
        'edit page',
        SingleChildScrollView(
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
                  icon: Image.asset(animalDict[stampName] ?? ''),
                  onPressed: () {},
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
            )
          ]),
        ),
        [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              ctrl.updateTrack(
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
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          openEditPage(context);
        },
        style: TextButton.styleFrom(
          primary: _color,
        ),
        child: Text(track['subject_name']),
      ),
    );
  }
}

class AddTrack extends StatefulWidget {
  const AddTrack({Key? key}) : super(key: key);
  @override
  _AddTrackState createState() => _AddTrackState();
}

class _AddTrackState extends State<AddTrack> {
  final Controller ctrl = Get.find();

  bool isClicked = false;
  TextEditingController nameTcr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isClicked
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    // decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Enter a search term'),
                    controller: nameTcr,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      if (nameTcr.text.isEmpty) {
                        print('empty text');
                        return;
                      }
                      ctrl.insertTrack(nameTcr.text);
                      nameTcr.text = '';
                      setState(() => isClicked = !isClicked);
                    },
                    child: Text('submit')),
                TextButton(
                    onPressed: () {
                      setState(() => isClicked = !isClicked);
                    },
                    child: Text('취소')),
              ],
            )
          : IconButton(
              icon: Icon(Icons.add),
              tooltip: '트랙 추가하기',
              color: Colors.yellow,
              onPressed: () {
                setState(() => isClicked = !isClicked);
                // print('pressed')
              },
            ),
    );
  }
}
