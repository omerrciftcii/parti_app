import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getDateTime(DateTime date) {
    return DateFormat().format(date);
  }
}
