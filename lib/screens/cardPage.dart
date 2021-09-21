import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// custom
import 'package:myapp/components/card/trackLine.dart';
import 'package:myapp/controller.dart';
import 'package:myapp/components/card/trackButton.dart';

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
