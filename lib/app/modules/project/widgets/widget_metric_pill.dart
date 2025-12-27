import 'package:flutter/material.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';

class WidgetMetricPill extends StatelessWidget {
  final String label;
  final String value;
  final bool
  isGood; // Determines color context if needed. For CPI/SPI > 1 is good usually

  const WidgetMetricPill({
    super.key,
    required this.label,
    required this.value,
    this.isGood = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.neutral300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodySM.copyWith(
              color: AppColors.neutral700,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTypography.bodySM.copyWith(
              color: AppColors.neutral900,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
