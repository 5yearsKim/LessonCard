import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'utils/stamp.dart';

class TrackLine extends StatelessWidget {
  final int trackId;
  final int maxStamp;
  final String stampName;
  TrackLine({required int this.trackId, int this.maxStamp = 7, String this.stampName = 'bear', Key? key}) : super(key: key) {}
  final Controller ctrl = Get.find();

  get stamps {
    print('stampname');
    print(stampName);
    return ctrl.stampDict[trackId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GetBuilder<Controller>(builder: (_) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < stamps.length; i++)
                Stamp(
                  trackId: trackId,
                  item: stamps[i],
                  stampName: stampName,
                ),
              for (int i = 0; i < maxStamp - stamps.length; i++)
                Stamp(
                  trackId: trackId,
                  item: null,
                  stampName: stampName,
                ),
            ],
          );
        }));
  }
}

class Stamp extends StatelessWidget {
  final dynamic item;
  final int trackId;
  final String stampName;
  Stamp({
    required int this.trackId,
    dynamic this.item,
    String this.stampName = 'bear',
    Key? key,
  }) : super(key: key);
  final Controller ctrl = Get.find();

  Widget StampImage({String stampName = 'bear', bool isHide = false}) {
    return Image.asset(
      animalDict[stampName] ?? '',
      color: isHide ? Colors.grey : null,
      // colorBlendMode: BlendMode.modulate,
      width: 30,
      height: 30,
      fit: BoxFit.contain,
    );
  }

  Widget Empty() {
    return IconButton(
      icon: StampImage(
        stampName: stampName,
        isHide: true,
      ),
      onPressed: () {
        ctrl.insertStamp(trackId);
      },
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget Filled() {
    return IconButton(
      icon: StampImage(
        stampName: stampName,
        isHide: false,
      ),
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
