import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class MoneyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String v = newValue.text;

    // Replace commas with periods and remove spaces
    v = v.replaceAll(" ", "").replaceAll('\u00A0', '').replaceAll(",", ".");

    // Allow only digits and one period (for decimals)
    v = v.replaceAll(RegExp(r'[^0-9\.]'), ''); // Keep only numbers and periods

    int index = v.indexOf('.');

    if (index != -1) {
      if (v.length > index + 2) {
        v = v.substring(0, index + 3);
      }
    }

    // If the string is empty, return an empty value
    if (v.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Parse the string into reports double
    double? parsedValue = _strimer(v);

    // If parsing fails, return the old value
    if (parsedValue == null) {
      return oldValue;
    }

    // Create reports number formatter
    NumberFormat oCcy = NumberFormat("#,##0.##", "uz");

    // Adjust formatting for specific decimal places
    if (v.endsWith(".")) {
      oCcy = NumberFormat("#,##0.", "uz");
    } else if (v.endsWith(".0")) {
      oCcy = NumberFormat("#,##0.0#", "uz");
    } else if (v.endsWith(".00")) {
      oCcy = NumberFormat("#,##0.00", "uz");
    }

    // Format the number
    String formattedValue =
        parsedValue != 0 ? oCcy.format(parsedValue) : oCcy.format(0);

    // Return the formatted text with correct cursor position
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.fromPosition(
          TextPosition(offset: formattedValue.length)),
    );
  }

  // String to double conversion with error handling
  double? _strimer(String text) {
    try {
      return double.parse(text);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }
}
