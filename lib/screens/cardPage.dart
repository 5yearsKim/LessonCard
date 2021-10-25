import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// custom
import 'package:myapp/components/card/trackLine.dart';
import 'package:myapp/components/card/cardNote.dart';
import 'package:myapp/components/card/trackButton.dart';
import 'package:myapp/controller.dart';
import 'package:myapp/tools/text.dart';
import 'package:myapp/utils/misc.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('card page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: CardPageWrapper(),
        ),
      ) 
    );
  }
}

class CardPageWrapper extends StatelessWidget {
  CardPageWrapper({Key? key}) : super(key: key);
  final Controller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
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
  }
}

class TrackList extends StatelessWidget {
  TrackList() {
    ctrl.bringTrackList();
    ctrl.bringStampList();
    ctrl.bringSubjectName();
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
                      for (var i = 0; i < ctrl.trackList.length; i++)
                        Row(
                          key: Key('${i}'),
                          children: [
                            TrackButton(i),
                            TrackLine(i),
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
    return Container(
      child: isClicked
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
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
                TextButton(
                    onPressed: () {
                      if (nameTcr.text.isEmpty) {
                        print('empty text');
                        return;
                      }
                      if (info == null) {
                        ctrl.insertTrack(nameTcr.text);
                      } else {
                        ctrl.insertTrack(nameTcr.text,
                          stampName: info['stamp_name'] ?? '',
                          color: info['color'] ?? '',
                          maxStamp: info['max_stamp'],
                        );
                      }
                      info = null;
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
