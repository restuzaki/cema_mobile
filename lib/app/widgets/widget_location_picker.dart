import 'package:flutter/material.dart';
import '../design_system/tokens/colors.dart';
import '../design_system/tokens/typography.dart';
import '../design_system/tokens/dimensions.dart';
import 'widget_input_field.dart';

class WidgetLocationPicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final VoidCallback? onMapTap;

  const WidgetLocationPicker({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetInputField(
          controller: controller,
          label: label,
          hint: hint,
          suffixIcon: const Icon(
            Icons.location_on_outlined,
            color: AppColors.primary500,
          ),
          // Validated as optional in plan, so no generic validator here unless passed
        ),
        const SizedBox(height: 12),
        // Placeholder Map Preview
        ClipRRect(
          borderRadius: AppRadius.radiusMd,
          child: Container(
            height: 150,
            width: double.infinity,
            color: AppColors.neutral100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Pattern (Optional, just simple grey for now)
                Icon(
                  Icons.map_outlined,
                  size: 64,
                  color: AppColors.neutral300.withOpacity(0.5),
                ),
                Positioned(
                  bottom: 16,
                  child: Text(
                    "Pratinjau Peta (Visual)",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                // "Select on Map" button (even if mock)
                if (onMapTap != null)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(onTap: onMapTap),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
