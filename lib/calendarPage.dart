import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'dbHelper.dart';

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
          MyCalender(),
          ScheduleBox()
        ],
      )
    );
  }
}

class MyCalender extends StatefulWidget {
  @override
  _MyCalenderState createState() => _MyCalenderState();
}

class _MyCalenderState extends State<MyCalender> {
  _MyCalenderState() {
    _refreshCardList();
  }
  final Controller ctrl = Get.find();
  final DBHelper dbCtrl = Get.find();

  void _onDaySelected(selectedDay, focusedDay) {
    if (!isSameDay(ctrl.selectedDay, selectedDay)) {
      ctrl.setSelectedDay(selectedDay);
    }
  }

  _refreshCardList() async {
    final data = await dbCtrl.listCard();
    print(data.toMap(()));
    // print(data.map((item) => {item.target_date : item.note}));
  }

  final eventDict = {};
  
  _getEventsFromDay(day) {
    return eventDict[day] ?? [];
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
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.purpleAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0)
            ),
            defaultDecoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0)
            ),
          ),
          selectedDayPredicate: (DateTime date) => isSameDay(date, ctrl.selectedDay),
          ),
        ),
    );
  }
}

class ScheduleBox extends StatelessWidget {
  ScheduleBox({ Key? key }) : super(key: key);
  final Controller ctrl = Get.find();
  final DBHelper dbCtrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: GetBuilder<Controller>(
          builder: (_) => Text('move to ${ctrl.selectedDay}')
        ),
        onPressed: () async {
          final data = await dbCtrl.listCard();
          // print(dbCtrl.db);
          // int cid = await dbCtrl.insertCard('1991-01-01', 'hellow');
        },
      )
    );
  }
}