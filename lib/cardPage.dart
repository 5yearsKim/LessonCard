import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'trackLine.dart';

import 'controller.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('card page'),
        ),
        body: Column(
          children: [
            Text('hello'),
            TrackList(),
            AddTrack(),
          ],
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
    return Container(
        height: 300,
        child: GetBuilder<Controller>(
            builder: (_) => ReorderableListView(
                  children: [
                    for (int i = 0; i < ctrl.trackList.length; i++)
                      Row(
                        key: Key('${i}'),
                        children: [
                          Text(ctrl.trackList[i]['subject_name']),
                          OutlinedButton(
                            child: Text('delete'),
                            onPressed: () => ctrl.deleteTrack(ctrl.trackList[i]['id']),
                          ),
                          TrackLine(
                            ctrl.trackList[i]['id'],
                            maxStamp: ctrl.trackList[i]['max_stamp'],
                            // maxStamp: 3,
                          )
                        ],
                      ),
                  ],
                  padding: EdgeInsets.all(10),
                  onReorder: (int oldIdx, int newIdx) {
                    ctrl.reorderTrack(oldIdx, newIdx);
                  },
                )));
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
    return Column(children: [
      isClicked
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Enter a search term'),
                    controller: nameTcr,
                  ),
                ),
                OutlinedButton(
                    onPressed: () {
                      if (nameTcr.text.isEmpty) {
                        print('empty text');
                        return;
                      }
                      ctrl.insertTrack(nameTcr.text);
                      nameTcr.text = '';
                    },
                    child: Text('submit')),
                OutlinedButton(
                    onPressed: () {
                      ctrl.bringTrackList();
                    },
                    child: Text('refresh')),
              ],
            )
          : OutlinedButton(
              child: Text('plus'),
              onPressed: () {
                setState(() => isClicked = !isClicked);
                // print('pressed')
              },
            ),
      Text('hh ${nameTcr.text}')
    ]);
  }
}
