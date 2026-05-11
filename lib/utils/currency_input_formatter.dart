import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formatter for currency input fields — handles locale-specific formatting.
///
/// Usage:
/// ```dart
/// final formatter = CurrencyInputFormatter(locale: 'en_US');
/// TextFormField(inputFormatters: [formatter], ...)
/// ```
class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({required this.locale}) {
    _formatter = NumberFormat('#,###', locale);
  }

  final String locale;
  late final NumberFormat _formatter;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Extract only digits
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Format with locale-specific thousand separators
    final num value = int.parse(digits);
    final formatted = _formatter.format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
