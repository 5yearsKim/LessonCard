import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//custom
import 'package:myapp/controller.dart';
import 'package:myapp/utils/misc.dart';
// import 'package:myapp/dbHelper.dart';
import 'package:myapp/utils/time.dart';

class CalendarPage extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          child: MyCalender(),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: Icon(Icons.insights),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[700],
                onPrimary: Colors.amber[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Get.toNamed('/analysis');
              },
              label: Text('데이터 분석'),
            )),
        MoveCard(),
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

class MoveCard extends StatelessWidget {
  MoveCard({Key? key}) : super(key: key);
  final Controller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(builder: (_) {
      bool hasCard = ctrl.todayCard != null && !ctrl.todayCard['note'].isEmpty;
      if (hasCard) {
        return InkWell(
          onTap: () async {
            await ctrl.insertCard('test');
            Get.toNamed('/card');
          },
          child: Container(
              child: ScheduleBox(),
              width: double.infinity,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              )),
        );
      }
      return Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          GetBuilder<Controller>(builder: (_) => Text('${datePrettify(ctrl.selectedDay)}')),
          Text('아직 연습 카드가 없어요. 연습카드를 추가해보세요.'),
          ClipOval(
            child: Material(
              color: Colors.amber, // Button color
              child: InkWell(
                splashColor: Colors.indigo[900], // Splash color
                onTap: () async {
                  await ctrl.insertCard('test');
                  Get.toNamed('/card');
                },
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    )),
              ),
            ),
          )
        ]),
      );
    });
  }
}

class ScheduleBox extends StatelessWidget {
  ScheduleBox({Key? key}) : super(key: key);
  // final DBHelper dbCtrl = Get.find();
  final Controller ctrl = Get.find();

  Widget wrapSubject() {
    return Container(
      // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: GetBuilder<Controller>(builder: (_) {
        return Wrap(
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          children: [
            for (final item in ctrl.trackList)
              Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: code2color(item['color']),
                  ),
                  child: Text(item['subject_name'], style: TextStyle(color: Colors.white))),
          ],
        );
      }),
    );
  }

  Widget todayNote() {
    return GetBuilder<Controller>(builder: (_) {
      bool hasNote = ctrl.todayCard != null && !ctrl.todayCard['note'].isEmpty;
      if (!hasNote) {
        return Container();
      }
      return Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                '연습 일지',
                style: TextStyle(
                  color: Colors.indigo[900],
                ),
              ),
              Text('${ctrl.todayCard['note']}'),
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: GetBuilder<Controller>(builder: (_) => Text('${datePrettify(ctrl.selectedDay)}',
            style: TextStyle(color: Colors.indigo[900]),
          )),
        ),
        Container(
          // margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              wrapSubject(),
              todayNote()
            ],
          ),
        )
      ],
    );
  }
}
