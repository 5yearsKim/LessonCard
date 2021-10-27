import 'package:intl/intl.dart';

String datePrettify(DateTime date, {lang: 'ko', withYear: false}) {
  if (withYear) {
    return DateFormat('M월 d일').format(date);
  } else {
    return DateFormat('M월 d일').format(date);
  }
}

String timePrettify(DateTime date, {withLang: false}) {
  String timeString = DateFormat.Hms().format(date);
  if (withLang) {
    final timeArr = timeString.split(':');
    return '${timeArr[0]}시 ${timeArr[1]}분 ${timeArr[2]}초';
  } else {
    return timeString;
  }
}

String secondsPrettify(double seconds) {
  if (seconds < 60) {
    return '${seconds.toStringAsFixed(1)}초';
  }
  int mins = seconds ~/ 60;
  if (mins < 60) {
    return '${mins}분';
  }
  int hours = mins ~/ 60;
  int remainder = mins % 60;
  return '${hours}시간 ${remainder}분';
}

