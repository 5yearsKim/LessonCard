import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// custom
import 'package:myapp/controller.dart';

class CardNote extends StatelessWidget {
  const CardNote({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('연습일지', 
          style: TextStyle(
            color: Colors.indigo[900],
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Theme.of(context).primaryColor,
            )
          ),
          child: CardNoteContent()
        ,)
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
            decoration: InputDecoration(
              labelText: '연습일지를 적어보세요!'
            ),
            controller: noteTcr,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  noteTcr.text = card['note'];
                  setState(() => isEdit = false);
                },
                child: Text('취소'),
              ),
              OutlinedButton(
                onPressed: () {
                  ctrl.updateCard(note: noteTcr.text);
                  setState(() => isEdit = false);
                },
                child: Text('저장'),
              )
            ],
          )
        ],
      );
    } else {
      return Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(noteTcr.text),
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: '수정하기',
            onPressed: () {
              setState(() => isEdit = true);
            },
          ),
        ],
      );
    }
  }
}
