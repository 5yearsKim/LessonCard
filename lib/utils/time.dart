import 'package:intl/intl.dart';

String datePrettify(DateTime date, {lang: 'ko', withYear: false}) {
  if (withYear) {
    return DateFormat('M월 d일').format(date);
  } else {
    return DateFormat('M월 d일').format(date);
  }
}

