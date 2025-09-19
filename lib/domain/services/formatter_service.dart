import 'package:intl/intl.dart';

class FormatterService {
  String formatNumber(String v, {bool isTyin = false, bool showTyin = false, bool moneySymbol = false, bool currencySymbol = false}) {
    try {
      if (v.isEmpty) return '0';

      if (isTyin) v = (double.parse(v) / 100).toString();
      if (v.endsWith(',')) v = v.replaceAll(',', '');
      if (v.contains('.') && v.split('.')[1].length > 2) v = backspaceSharp(v);

      NumberFormat format = NumberFormat("#,##0.00", "uz");
      if (!showTyin) format = NumberFormat("#,##0", "uz");

      String result = format.format(strimmerDouble(v));

      if (currencySymbol) {
        result += ' ${NumberFormat.currency(locale: "uz", decimalDigits: 2).currencySymbol}';
      } else if (moneySymbol) {
        result = NumberFormat.currency(locale: "uz", decimalDigits: 2).format(strimmerDouble(v));
      }

      return result;
    } catch (_) {
      return '0';
    }
  }

  String backspaceSharp(String sum){
    if (sum.isNotEmpty) {
      String v = strimmerText(sum).toString();
      return formatNumber(v.toString().substring(0, v
          .toString()
          .length - 1), currencySymbol: false);
    }
    return sum;
  }

  String strimmerText(String text) {
    return text.replaceAll(" ", "").replaceAll('\u00A0', '').replaceAll(",", ".").replaceAll(NumberFormat.currency(locale: "uz",decimalDigits: 2).currencySymbol, "");
  }

  double strimmerDouble(String text) {
    // Удаляем все пробелы, неразрывные пробелы, символы валюты и заменяем запятую на точку
    String cleanedText = text.replaceAll(" ", "")
        .replaceAll('\u00A0', '')
        .replaceAll(",", ".")
        .replaceAll(NumberFormat.currency(locale: "uz", decimalDigits: 2).currencySymbol, "");

    // Удаляем точку или запятую в конце, если они есть
    if (cleanedText.endsWith(".") || cleanedText.endsWith(",")) {
      cleanedText = cleanedText.substring(0, cleanedText.length - 1);
    }

    // Возвращаем число
    return double.tryParse(cleanedText) ?? 0;
  }

  String dateFormatter(String? dateString) {
    DateTime dateTime;
    if((dateString?.contains(" ") ?? false) || (dateString?.contains("T") ?? false)) {
      dateTime = DateTime.parse(dateString!);
    }
    else if(dateString != null && dateString.isNotEmpty) {
      int year = int.parse(dateString.substring(0, 4));
      int month = int.parse(dateString.substring(4, 6));
      int day = int.parse(dateString.substring(6, 8));
      int hour = int.parse(dateString.substring(8, 10));
      int minute = int.parse(dateString.substring(10, 12));
      int second = int.parse(dateString.substring(12, 14));
      dateTime = DateTime(year, month, day, hour, minute, second);
    } else {
      dateTime = DateTime.now();
    }

    return DateFormat("dd-MM-yyyy HH:mm:ss").format(dateTime);
  }

  String reverseDateFormatter(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    return '$year$month$day$hour$minute$second';
  }

  String datePosFormatter(String? dateString) {
    DateTime dateTime;

    if (dateString == null || dateString.isEmpty) {
      dateTime = DateTime.now();
    } else if (RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(dateString)) {
      // Формат dd.MM.yyyy
      final parts = dateString.split('.');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      dateTime = DateTime(year, month, day);
    } else if (dateString.length >= 14) {
      int year = int.parse(dateString.substring(0, 4));
      int month = int.parse(dateString.substring(4, 6));
      int day = int.parse(dateString.substring(6, 8));
      int hour = int.parse(dateString.substring(8, 10));
      int minute = int.parse(dateString.substring(10, 12));
      int second = int.parse(dateString.substring(12, 14));
      dateTime = DateTime(year, month, day, hour, minute, second);
    } else {
      try {
        dateTime = DateTime.parse(dateString);
      } catch (_) {
        dateTime = DateTime.now();
      }
    }

    return dateTime.toIso8601String();
  }


  String? datePosParser(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;

    try {
      DateTime dateTime = DateTime.parse(isoString).toUtc().add(const Duration(hours: 5));
      String formatted = dateTime.year.toString().padLeft(4, '0') +
          dateTime.month.toString().padLeft(2, '0') +
          dateTime.day.toString().padLeft(2, '0') +
          dateTime.hour.toString().padLeft(2, '0') +
          dateTime.minute.toString().padLeft(2, '0') +
          dateTime.second.toString().padLeft(2, '0');
      return formatted;
    } catch (e) {
      return null;
    }
  }


  String dateFormatterWithTimeZone(String dateString) {
    final parsedDate = DateTime.parse(dateString); // Парсим строку в DateTime
    return DateFormat('dd-MM-yyyy HH:mm').format(parsedDate);
  }
}