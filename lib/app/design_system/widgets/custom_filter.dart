// lib/app/design_system/widgets/custom_filter.dart
import 'package:flutter/material.dart';
import '../design_system.dart';

/// Custom filter/tab widget with active indicator
class CustomFilter extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;

  const CustomFilter({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.textLight;
    final effectiveInactiveColor =
        inactiveColor ?? AppColors.textSecondaryLight;
    final effectiveIndicatorColor = indicatorColor ?? AppColors.textLight;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodyLG.copyWith(
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? effectiveActiveColor : effectiveInactiveColor,
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
          Container(
            height: 3,
            width: 32,
            decoration: BoxDecoration(
              color: isActive ? effectiveIndicatorColor : Colors.transparent,
              borderRadius: AppRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
