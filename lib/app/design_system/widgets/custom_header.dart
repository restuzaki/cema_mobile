// lib/app/design_system/widgets/custom_header.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../design_system.dart';

/// Custom header widget with back button and title
/// Can be used as AppBar via PreferredSizeWidget
class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;
  final Widget? child;

  const CustomHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.trailing,
    this.child,
  });

  @override
  Size get preferredSize => Size.fromHeight(child != null ? 130 : 80);

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ?? AppColors.backgroundLight;
    final effectiveIconColor = iconColor ?? AppColors.primary500;
    final effectiveTextColor = textColor ?? AppColors.textLight;

    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.lg),
          bottomRight: Radius.circular(AppRadius.lg),
        ),
        boxShadow: AppShadows.shadowSm,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (showBackButton)
                  _BackButton(
                    onPressed: onBackPressed ?? () => Get.back(),
                    iconColor: effectiveIconColor,
                  ),
                if (showBackButton) SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.headingLG.copyWith(
                      color: effectiveTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: AppSpacing.sm),
                  trailing!,
                ],
              ],
            ),
            if (child != null) ...[SizedBox(height: AppSpacing.sm), child!],
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color iconColor;

  const _BackButton({required this.onPressed, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: iconColor, width: 2),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.arrow_back, color: iconColor, size: AppIconSize.md),
        onPressed: onPressed,
      ),
    );
  }
}
