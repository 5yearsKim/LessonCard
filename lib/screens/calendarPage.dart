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
import 'package:myapp/config.dart';

class CalendarPage extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  primary: lightenColor(secondaryColor, amount: 0.5),
                  onPrimary: lightenColor(primaryColor, amount: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Get.toNamed('/analysis');
                },
                label: Text('데이터 분석', style: TextStyle(fontWeight: FontWeight.bold)),
              )),
          MoveCard(),
        ],
      ),
    );
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
          selectedDayPredicate: (DateTime date) {
            return isSameDay(date, ctrl.selectedDay);
          },
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: primaryColor, 
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle().copyWith(color: Colors.red),
            holidayTextStyle: TextStyle().copyWith(color: Colors.blue[800]),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            headerMargin: EdgeInsets.only(left: 40, top: 0, right: 40, bottom: 10),
            leftChevronIcon: Icon(Icons.arrow_left),
            rightChevronIcon: Icon(Icons.arrow_right),
            titleTextStyle: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          locale: 'ko-KR',
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) {
                return null;
              }
              return Positioned(
                bottom: 4,
                right: 1,
                child: Icon(Icons.check, color: Colors.green),
              );
            },
          ),
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
            await ctrl.insertCard('');
            Get.toNamed('/card');
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: ScheduleBox(),
          ),
        );
      }
      return Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: [
          GetBuilder<Controller>(builder: (_) {
            return Text(
              '${datePrettify(ctrl.selectedDay)}',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
            );
          }),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              '아직 연습 카드가 없어요. 연습카드를 추가해보세요.',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
          ),
          ClipOval(
            child: Material(
              color: primaryColor, // Button color
              child: InkWell(
                splashColor: secondaryColor, // Splash color
                onTap: () async {
                  await ctrl.insertCard('');
                  Get.toNamed('/card');
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
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

  Widget wrapSubject(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(20),
                  color: code2color(item['color']),
                ),
                child: Text(
                  item['subject_name'],
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: textOnColor(
                          code2color(item['color']),
                        ),
                      ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget todayNote(context) {
    return GetBuilder<Controller>(builder: (_) {
      bool hasNote = ctrl.todayCard != null && !ctrl.todayCard['note'].isEmpty;
      if (!hasNote) {
        return Container();
      }
      return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: Column(
            children: [
              Text(
                '연습 일지',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  '${ctrl.todayCard['note']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ),
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(6),
          child: GetBuilder<Controller>(
              builder: (_) => Text(
                    '${datePrettify(ctrl.selectedDay)}',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: textColor, fontWeight: FontWeight.bold),
                  )),
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [wrapSubject(context), todayNote(context)],
          ),
        )
      ],
    );
  }
}
