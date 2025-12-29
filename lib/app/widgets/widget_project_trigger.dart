import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../design_system/tokens/colors.dart';
import '../design_system/tokens/typography.dart';
import '../design_system/tokens/dimensions.dart';

class WidgetProjectTrigger extends StatelessWidget {
  final String? selectedProjectName;
  final bool isLocked;
  final VoidCallback? onTap;

  const WidgetProjectTrigger({
    super.key,
    this.selectedProjectName,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pilih Proyek",
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: AppRadius.radiusMd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isLocked
                  ? AppColors.neutral300.withOpacity(0.3)
                  : AppColors.neutral100,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.neutral300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.business_center_outlined, // Project icon
                  color: isLocked
                      ? AppColors.textSecondaryLight
                      : AppColors.primary500,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedProjectName ?? "Pilih Proyek...",
                    style: AppTypography.bodyMD.copyWith(
                      color: selectedProjectName != null
                          ? (isLocked
                                ? AppColors.textSecondaryLight
                                : AppColors.textLight)
                          : AppColors.textSecondaryLight.withOpacity(0.5),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isLocked)
                  Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondaryLight,
                    size: 18,
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondaryLight,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
