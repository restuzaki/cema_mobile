import 'package:flutter/material.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';

enum BadgeStatus { success, warning, danger, neutral }

class WidgetStatusBadge extends StatelessWidget {
  final String text;
  final BadgeStatus status;

  const WidgetStatusBadge({
    super.key,
    required this.text,
    required this.status,
  });

  Color get _backgroundColor {
    switch (status) {
      case BadgeStatus.success:
        return AppColors.success100;
      case BadgeStatus.warning:
        return AppColors.warning100;
      case BadgeStatus.danger:
        return AppColors.error100;
      case BadgeStatus.neutral:
      default:
        return AppColors.neutral100;
    }
  }

  Color get _textColor {
    switch (status) {
      case BadgeStatus.success:
        return AppColors.success700;
      case BadgeStatus.warning:
        return AppColors.warning700;
      case BadgeStatus.danger:
        return AppColors.error700;
      case BadgeStatus.neutral:
      default:
        return AppColors.neutral700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(100), // Pill shape
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: _textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
