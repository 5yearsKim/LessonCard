import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// custom
import 'package:myapp/controller.dart';

class CardNote extends StatefulWidget {
  const CardNote({Key? key}) : super(key: key);

  @override
  _CardNoteState createState() => _CardNoteState();
}

class _CardNoteState extends State<CardNote> {
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
            decoration: InputDecoration(border: OutlineInputBorder(), labelText: '연습일지를 적어보세요!'),
            controller: noteTcr,
          ),
          OutlinedButton(
            onPressed: () {
              ctrl.updateCard(note: noteTcr.text);
              setState(() => isEdit = false);
            },
            child: Text('저장'),
          )
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(noteTcr.text),
          TextButton(
            onPressed: () {
              setState(() => isEdit = true);
            },
            child: Text('수정하기'),)
        ],
      );
    }
  }
}
