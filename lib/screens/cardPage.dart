import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// custom
import 'package:lessoncard/components/card/trackLine.dart';
import 'package:lessoncard/components/card/cardNote.dart';
import 'package:lessoncard/components/card/trackButton.dart';
import 'package:lessoncard/config.dart';
import 'package:lessoncard/controller.dart';
import 'package:lessoncard/tools/text.dart';
import 'package:lessoncard/utils/misc.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).orientation == Orientation.landscape
          ? null
          : AppBar(
              title: Text(
                'Card'.tr,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
      body: SingleChildScrollView(
        child: Center(
          child: CardPageWrapper(),
        ),
      ),
    );
  }
}

class CardPageWrapper extends StatelessWidget {
  CardPageWrapper({Key? key}) : super(key: key);
  final Controller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
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
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: CardNote(),
          ),
        ],
      );
    } else {
      return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TrackList(),
            AddTrack(),
          ],
        ),
      );
    }
  }
}

class TrackList extends StatelessWidget {
  TrackList() {
    ctrl.bringTrackList();
    ctrl.bringStampList();
    ctrl.bringSubjectName();
  }

  final Controller ctrl = Get.find();

  double _width(context) {
    int maxCnt = 5;
    int stampSize = MediaQuery.of(context).orientation == Orientation.portrait ? STAMP_SIZE_SMALL : STAMP_SIZE_LARGE;
    for (var item in ctrl.trackList) {
      int cnt = item['max_stamp'] ?? 7;
      if (cnt > maxCnt) maxCnt = cnt;
    }
    for (List<dynamic> item in ctrl.stampDict.values) {
      int cnt = item.length;
      if (cnt > maxCnt) maxCnt = cnt;
    }
    return 180.0 + stampSize * maxCnt;
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GetBuilder<Controller>(
        builder: (_) => Container(
          width: _width(context),
          child: ReorderableListView(
            shrinkWrap: true,
            children: [
              for (var i = 0; i < ctrl.trackList.length; i++)
                Row(
                  key: Key('${i}'),
                  children: [
                    TrackButton(i),
                    TrackLine(i),
                  ],
                ),
            ],
            padding: EdgeInsets.all(5),
            onReorder: (int oldIdx, int newIdx) {
              ctrl.reorderTrack(oldIdx, newIdx);
            },
          ),
        ),
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

  dynamic info = null;

  @override
  void initState() {
    super.initState();
    nameTcr.addListener(() {
      if (nameTcr.text == '') {
        setState(() => info = null);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    ctrl.bringAllStamp();
    ctrl.bringSubjectName();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: isClicked
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      textAlign: TextAlign.center,
                      maxLength: MAX_TRACKNAME_LEN,
                      controller: nameTcr,
                      style: TextStyle(
                        color: info == null ? null : code2color(info['color']),
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return ctrl.subjectName.where(
                        (item) => item['subject_name'].toLowerCase().contains(pattern.toLowerCase()),
                      );
                    },
                    itemBuilder: (_, item) {
                      dynamic myitem = item;
                      return ListTile(
                        title: ColorText(myitem['subject_name'], myitem['color']),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() => info = suggestion);
                      // print(info);
                      nameTcr.text = (suggestion as dynamic)['subject_name'];
                    },
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    setState(() => isClicked = !isClicked);
                  },
                  child: Text('cancel'.tr),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    if (nameTcr.text.isEmpty) {
                      // print('empty text');
                      return;
                    }
                    if (info == null) {
                      ctrl.insertTrack(nameTcr.text);
                    } else {
                      ctrl.insertTrack(
                        nameTcr.text,
                        stampName: info['stamp_name'] ?? '',
                        color: info['color'] ?? '',
                        maxStamp: info['max_stamp'],
                      );
                    }
                    info = null;
                    nameTcr.text = '';
                    setState(() => isClicked = !isClicked);
                  },
                  child: Text('ok'.tr, style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          : IconButton(
              icon: Icon(Icons.add),
              tooltip: 'msgAddTrack'.tr,
              color: Colors.yellow,
              onPressed: () {
                setState(() => isClicked = !isClicked);
                // print('pressed')
              },
            ),
    );
  }
}
