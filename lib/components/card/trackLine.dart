import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// custom
import 'package:myapp/controller.dart';
import 'package:myapp/utils/stamp.dart';

class TrackLine extends StatelessWidget {
  final int trackId;
  final int maxStamp;
  final String stampName;
  TrackLine({required int this.trackId, int this.maxStamp = 7, String this.stampName = '', Key? key}) : super(key: key) {}
  final Controller ctrl = Get.find();

  get stamps {
    // print('stampname');
    // print(stampName);
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

  void alertDelete(BuildContext context, Function onOk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('도장 지우기'),
          content: Text('도장을 지울까요?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOk();
              },
              child: Text('지우기'),
            )
          ],
        );
      }
    );
  }

  Widget StampImage({String stampName = '', bool isHide = false}) {
    if (stampName.isEmpty) {
      stampName = 'bear';
    }
    return Image.asset(
      animalDict[stampName] ?? '',
      color: isHide ? Colors.grey : null,
      // colorBlendMode: BlendMode.modulate,
      width: 30,
      height: 30,
      fit: BoxFit.contain,
    );
  }

  Widget Empty(BuildContext context) {
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

  Widget Filled(BuildContext context) {
    return IconButton(
      icon: StampImage(
        stampName: stampName,
        isHide: false,
      ),
      tooltip: item['note'],
      onPressed: () {
        Function onOk = () {
          if (item != null)
            ctrl.deleteStamp(trackId, item['id']);
        };
        alertDelete(context, onOk);
      },
      padding: EdgeInsets.all(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: item == null ? Empty(context) : Filled(context),
    );
  }
}
