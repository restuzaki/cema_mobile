// lib/app/design_system/widgets/status_label.dart
import 'package:flutter/material.dart';
import '../design_system.dart';

/// Status label widget for displaying status badges
class StatusLabel extends StatelessWidget {
  final String label;
  final StatusLabelType type;
  final IconData? icon;

  const StatusLabel({
    super.key,
    required this.label,
    required this.type,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppRadius.radiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppIconSize.sm, color: _getTextColor()),
            SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case StatusLabelType.warning:
        return AppColors.warning100;
      case StatusLabelType.success:
        return AppColors.success100;
      case StatusLabelType.error:
        return AppColors.error100;
      case StatusLabelType.info:
        return AppColors.neutral100;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case StatusLabelType.warning:
        return AppColors.warning700;
      case StatusLabelType.success:
        return AppColors.success700;
      case StatusLabelType.error:
        return AppColors.error700;
      case StatusLabelType.info:
        return AppColors.neutral700;
    }
  }
}

/// Status label types
enum StatusLabelType { warning, success, error, info }
