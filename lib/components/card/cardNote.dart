import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// custom
import 'package:lessoncard/controller.dart';
import 'package:lessoncard/utils/time.dart';
import 'package:lessoncard/config.dart';

class CardNote extends StatelessWidget {
  CardNote({Key? key}) : super(key: key);
  final Controller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'practiceNote'.tr,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.fromLTRB(0, 0, 5, 10),
          child: GetBuilder<Controller>(builder: (_) {
            return Text(
              '${datePrettify(ctrl.selectedDay)}',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            );
          }),
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[200],
          ),
          child: CardNoteContent(),
        ),
      ],
    );
  }
}

class CardNoteContent extends StatefulWidget {
  const CardNoteContent({Key? key}) : super(key: key);

  @override
  _CardNoteContentState createState() => _CardNoteContentState();
}

class _CardNoteContentState extends State<CardNoteContent> {
  final Controller ctrl = Get.find();
  final noteTcr = TextEditingController();
  bool isEdit = false;

  get card {
    return ctrl.todayCard;
  }

  @override
  void initState() {
    super.initState();
    noteTcr.text = card['note'];
  }

  @override
  Widget build(BuildContext context) {
    if (isEdit) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'msgWriteNote'.tr),
            controller: noteTcr,
            minLines: 1,
            maxLines: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  noteTcr.text = card['note'];
                  setState(() => isEdit = false);
                },
                child: Text('cancel'.tr),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  ctrl.updateCard(note: noteTcr.text);
                  setState(() => isEdit = false);
                },
                child: Text('save'.tr),
              )
            ],
          )
        ],
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                noteTcr.text,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.grey[800],
                    ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Draggable(
                feedback: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        Colors.yellow,
                        Colors.transparent,
                      ])),
                ),
                childWhenDragging: Container(),
                child: FloatingActionButton.small(
                  onPressed: () {
                    setState(() => isEdit = true);
                  },
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit, size: 30),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
