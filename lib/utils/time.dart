import 'package:intl/intl.dart';

String datePrettify(DateTime date, {lang: 'ko', withYear: false}) {
  if (withYear) {
    return DateFormat('M월 d일').format(date);
  } else {
    return DateFormat('M월 d일').format(date);
  }
}

String secondsPrettify(double seconds) {
  if (seconds < 60) {
    return '${seconds}초';
  }
  int mins = seconds ~/ 60;
  if (mins < 60) {
    return '${mins}분';
  }
  int hours = mins ~/ 60;
  int remainder = mins % 60;
  return '${hours}시간 ${remainder}분';
}

