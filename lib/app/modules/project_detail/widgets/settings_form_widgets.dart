import 'package:flutter/material.dart';
import 'package:cema_mobile/app/design_system/design_system.dart';

class WidgetInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const WidgetInputField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class WidgetCurrencyInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? subLabel;

  const WidgetCurrencyInput({
    super.key,
    required this.label,
    required this.controller,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            prefixText: 'Rp ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
        if (subLabel != null) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            subLabel!,
            style: AppTypography.bodySM.copyWith(
              color: AppColors.textSecondaryLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class WidgetPhasePicker extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const WidgetPhasePicker({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class WidgetDateRangePicker extends StatelessWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  const WidgetDateRangePicker({
    super.key,
    required this.startController,
    required this.endController,
    required this.onStartTap,
    required this.onEndTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: startController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Start Date",
              suffixIcon: Icon(Icons.calendar_today, size: AppIconSize.sm),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            onTap: onStartTap,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: TextField(
            controller: endController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "End Date",
              suffixIcon: Icon(Icons.calendar_today, size: AppIconSize.sm),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            onTap: onEndTap,
          ),
        ),
      ],
    );
  }
}
