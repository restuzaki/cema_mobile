import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../design_system/tokens/colors.dart';
import '../design_system/tokens/typography.dart';
import 'widget_input_field.dart';

class WidgetCurrencyInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;

  const WidgetCurrencyInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetInputField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: TextInputType.number,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "IDR",
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      validator: validator,
      // Simple formatter to allow digits only, real-time currency formatting can be complex
      // and might be better handled by a library or simple logic in controller.
      // For now, ensuring digits only.
      // TODO: Add complex currency formatter if stricter UX needed.
    );
  }
}

/// Formatter for Currency (IDR)
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    );
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
