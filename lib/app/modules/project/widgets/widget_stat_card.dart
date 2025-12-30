import 'package:cema_mobile/app/design_system/tokens/dimensions.dart';
import 'package:flutter/material.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';

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

  final TextStyle labelStyle = AppTypography.labelSmall;
  final TextStyle valueStyle = AppTypography.bodyLG;
  final TextStyle trendStyle = AppTypography.bodySM;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.neutral000,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: labelStyle.copyWith(color: AppColors.neutral500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(value, style: valueStyle),
          if (trend != null) ...[
            Text(
              trend!,
              style: trendStyle.copyWith(
                color: isTrendPositive
                    ? AppColors.success700
                    : AppColors.error700,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static double get height {
    return AppTypography.labelSmall.fontSize! *
            AppTypography.labelSmall.height! +
        AppTypography.bodyLG.fontSize! * AppTypography.bodyLG.height! +
        AppTypography.bodySM.fontSize! * AppTypography.bodySM.height! +
        2 * AppSpacing.sm;
  }
}
