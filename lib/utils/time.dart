import 'package:intl/intl.dart';
import 'package:get/get.dart';

String datePrettify(DateTime date, {withYear: false}) {
  if (Get.locale.toString() == 'ko_KR') {
    if (withYear) {
      return DateFormat('y년 M월 d일').format(date);
    } else {
      return DateFormat('M월 d일').format(date);
    }
  } else {
    if (withYear) {
      return DateFormat('yMMMMd').format(date);
    } else {
      return DateFormat('MMMMd').format(date);
    }
  }
}

String timePrettify(DateTime date, {withLang: false}) {
  String timeString = DateFormat.Hms().format(date);
  if (withLang) {
    final timeArr = timeString.split(':');
    // return '${timeArr[0]}시 ${timeArr[1]}분 ${timeArr[2]}초';
    return 'NhoursMminSsec'.trParams({
      'N': timeArr[0],
      'M': timeArr[1],
      'S': timeArr[2], 
    });
  } else {
    return timeString;
  }
}

String secondsPrettify(double seconds) {
  if (seconds < 60) {
    // return '${seconds.toStringAsFixed(1)}초';
    return 'Nsec'.trParams({
      'N': seconds.toStringAsFixed(1),
    });
  }
  int mins = seconds ~/ 60;
  if (mins < 60) {
    // return '${mins}분';
    return 'Nmin'.trParams({
      'N': mins.toString(),
    });
  }
  int hours = mins ~/ 60;
  int remainder = mins % 60;
  // return '${hours}시간 ${remainder}분';
  return 'NhoursMmin'.trParams({
    'N': hours.toString(),
    'M': remainder.toString(),
  });
}

