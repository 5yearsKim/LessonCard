import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class TrackLine extends StatelessWidget {
  final int trackId;
  final int maxStamp;
  TrackLine(int this.trackId, {int? maxStamp, Key? key})
      : maxStamp = maxStamp ?? 7,
        super(key: key) {}
  final Controller ctrl = Get.find();

  get stamps {
    return ctrl.stampDict[trackId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 30,
        child: GetBuilder<Controller>(builder: (_) {
          return Row(
            children: [
              for (int i = 0; i < stamps.length; i++) Expanded(child: Stamp(trackId, stamps[i])),
              for (int i = 0; i < maxStamp - stamps.length; i++) Expanded(child: Stamp(trackId, null)),
            ],
          );
        }));
  }
}

class Stamp extends StatelessWidget {
  final item;
  final trackId;
  Stamp(int this.trackId, dynamic this.item, {Key? key}) : super(key: key);
  final Controller ctrl = Get.find();

  Widget Empty() {
    return IconButton(
      icon: Icon(Icons.access_time),
      onPressed: () {
        ctrl.insertStamp(trackId);
      },
    );
  }

  Widget Filled() {
    return IconButton(
      icon: Icon(Icons.access_time_filled),
      tooltip: item['note'],
      onPressed: () {
        if (item != null) ctrl.deleteStamp(trackId, item['id']);
      },
      padding: EdgeInsets.all(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: item == null ? Empty() : Filled());
  }
}
