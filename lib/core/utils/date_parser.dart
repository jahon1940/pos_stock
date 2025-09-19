

import 'package:intl/intl.dart';

class DateParser {
  static String monthToString(String? date, String? local) {
    if (date == null || local == null) return '';
    try {
      final DateTime parsing = DateTime.parse(date);
      if (parsing.year < DateTime.now().year ||
          parsing.year > DateTime.now().year) {
        return onlyMonthDayYearToString(parsing, local);
      } else {
        return DateFormat('d MMMM', local).format(parsing).toString();
      }
    } catch (e) {
      return '';
    }
  }

  static String onlyMonthDayYearToString(DateTime? time, String? local) {
    if (time == null || local == null) return '';
    try {
      return DateFormat('d MMMM yyyy', local).format(time).toString();
    } catch (e) {
      return '';
    }
  }

  static String expireDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String dayMonthHString(DateTime? date, String? local) {
    if (date == null || local == null) return '';
    try {
      final now = DateTime.now();
      if (date.toLocal().month == now.month && date.toLocal().day == now.day) {
        return "Сегодня ${DateFormat('HH:mm', local).format(date.toLocal())}";
      } else if (date.toLocal().month == now.month &&
          date.toLocal().day == now.day - 1) {
        return "Вчера ${DateFormat('HH:mm', local).format(date.toLocal())}";
      }

      if (now.year > date.year) {
        return DateFormat('d MMMM y HH:mm', local).format(date);
      }
      return DateFormat('d MMMM HH:mm', local).format(date);
    } catch (e) {
      return '';
    }
  }

  static String personDate(String? value, String? local) {
    if (value == null) return '';
    final List<String> res = value.split('-');
    DateTime time =
        DateTime(int.parse(res[0]), int.parse(res[1]), int.parse(res[2]));
    if (res[0] == '0002') {
      return DateFormat('d MMMM', local).format(time).toString();
    }
    return DateFormat('d MMMM, y', local).format(time).toString();
  }
}
