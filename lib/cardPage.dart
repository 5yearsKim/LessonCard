import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class CardPage extends StatelessWidget {
  const CardPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('card page'),
      ),
      body: Column(
        children: [
          Text('hello'),
          AddTrack(),
        ],
      )
    );
  }
}


class AddTrack extends StatefulWidget {
  const AddTrack({ Key? key }) : super(key: key);
  @override
  _AddTrackState createState() => _AddTrackState();
}

class _AddTrackState extends State<AddTrack> {
  bool isClicked = false;
  String trackName = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: 
        [
          isClicked?
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term'
            ),
            onChanged: (value) {
              setState(() {
                trackName = value;
              });
            },
          ) :
          OutlinedButton(
            child: Text('plus'),
            onPressed: () {
              setState(() {
                isClicked = !isClicked;
              });
              print('pressed');
            },
          ),
          Text('hh ${trackName}')
        ]
    );
  }
}
