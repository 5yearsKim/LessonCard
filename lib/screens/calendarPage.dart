import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//custom
import 'package:myapp/controller.dart';
import 'package:myapp/tools/text.dart';
// import 'package:myapp/dbHelper.dart';

class CalendarPage extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('calendar page'),
        ),
        body: Column(
          children: [
            Container(
              child: MyCalender(),
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
                child: ScheduleBox(),
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ))
          ],
        ));
  }
}

class MyCalender extends StatefulWidget {
  @override
  _MyCalenderState createState() => _MyCalenderState();
}

class _MyCalenderState extends State<MyCalender> {
  final Controller ctrl = Get.find();
  // final DBHelper dbCtrl = Get.find();

  _MyCalenderState() {
    ctrl.bringCardList();
  }

  var eventDict = {};

  void _onDaySelected(selectedDay, focusedDay) async {
    if (!isSameDay(ctrl.selectedDay, selectedDay)) {
      ctrl.setSelectedDay(selectedDay);
      await ctrl.bringTrackList();
      print(ctrl.trackList);
    }
  }

  List<dynamic> _getEventsFromDay(DateTime day) {
    final dayFormat = DateFormat('yyyy-MM-dd').format(day);
    var card = ctrl.cardDict[dayFormat];
    var event = [];
    if (card != null) {
      for (var i = 0; i < card['track_cnt']; i++) {
        event.add('.');
      }
    }
    // print('event ${formatDay} ${event}');
    return event;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<Controller>(
        builder: (_) => TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: ctrl.selectedDay,
          onDaySelected: _onDaySelected,
          eventLoader: _getEventsFromDay,
          // calendarStyle: CalendarStyle(
          //   isTodayHighlighted: true,
          //   selectedDecoration: BoxDecoration(
          //     color: Colors.blue,
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          //   todayDecoration: BoxDecoration(
          //     color: Colors.purpleAccent,
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          // ),
          selectedDayPredicate: (DateTime date) => isSameDay(date, ctrl.selectedDay),
        ),
      ),
    );
  }
}

class ScheduleBox extends StatelessWidget {
  ScheduleBox({Key? key}) : super(key: key);
  final Controller ctrl = Get.find();
  // final DBHelper dbCtrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: GetBuilder<Controller>(builder: (_) => Text('${ctrl.selectedDay}')),
        ),
        Container(
            child: ElevatedButton(
          child: Text('move to lecture card'),
          onPressed: () async {
            await ctrl.insertCard('test');
            Get.toNamed('/card');
          },
        )),
        GetBuilder<Controller>(builder: (_) {
          return Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: [
              for (final item in ctrl.trackList)
                ColorText(item['subject_name'], item['color'])
            ],
          );
        }),
        Container(child: GetBuilder<Controller>(builder: (_) {
          return ctrl.todayCard == null ? Text('') : Text('note: ${ctrl.todayCard['note']}');
        })),
      ],
    );
  }
}

