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
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Get.toNamed('/analysis');
            },
            child: Text('데이터 분석'),
          )
        ),
        Container(
          child: MyCalender(),
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        InkWell(
          onTap: () async {
            await ctrl.insertCard('test');
            Get.toNamed('/card');
          },
          child: Container(
              child: ScheduleBox(),
              width: double.infinity,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              )),
        ),
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
          selectedDayPredicate: (DateTime date) =>
              isSameDay(date, ctrl.selectedDay),
        ),
      ),
    );
  }
}

class ScheduleBox extends StatelessWidget {
  ScheduleBox({Key? key}) : super(key: key);
  // final DBHelper dbCtrl = Get.find();
  final Controller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child:
              GetBuilder<Controller>(
                builder: (_) => Text('${datePrettify(ctrl.selectedDay)}')
              ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                      child: Text(item['subject_name'],
                          style: TextStyle(color: Colors.white))),
              ],
            );
          }),
        ),

        // note
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((10)),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).primaryColor,
                )),
            child: Column(
              children: [
                Text(
                  '연습 일지',
                  style: TextStyle(
                    color: Colors.indigo[900],
                  ),
                ),
                GetBuilder<Controller>(builder: (_) {
                  return ctrl.todayCard == null
                      ? Text('')
                      : Text('${ctrl.todayCard['note']}');
                }),
              ],
            )),
      ],
    );
  }
}
