import 'package:flutter/material.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';
import '../../../design_system/tokens/shadows.dart';

class WidgetStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool isTrendPositive;

  const WidgetStatCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.isTrendPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.neutral000,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral300),
          // boxShadow: [AppShadows.cardShadow], // Assuming AppShadows exists
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.neutral700,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTypography.headingLG.copyWith(
                // Reduced from XL to LG for better fit in row of 3
                color: AppColors.neutral900,
                fontSize: 20, // Override to fit constraints
              ),
            ),
            if (trend != null) ...[
              const SizedBox(height: 4),
              Text(
                trend!,
                style: AppTypography.bodySM.copyWith(
                  color: isTrendPositive
                      ? AppColors.success700
                      : AppColors.error700,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
