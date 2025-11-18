// lib/app/design_system/widgets/custom_fab.dart
import 'package:flutter/material.dart';
import '../design_system.dart';

/// Custom Floating Action Button with multiple variants and sizes
class CustomFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final FabVariant variant;
  final FabSize size;
  final FabTheme theme;
  final bool isDisabled;

  const CustomFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = FabVariant.primary,
    this.size = FabSize.large,
    this.theme = FabTheme.light,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _getSize(),
      height: _getSize(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBackgroundColor(),
        border: Border.all(
          color: isDisabled ? AppColors.neutral500 : _getIconColor(),
          width: variant == FabVariant.secondary ? 2 : 0,
        ),
        boxShadow: isDisabled ? [] : AppShadows.shadowLg,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(icon, size: _getIconSize(), color: _getIconColor()),
          ),
        ),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case FabSize.small:
        return 32;
      case FabSize.large:
        return 56;
    }
  }

  double _getIconSize() {
    switch (size) {
      case FabSize.small:
        return AppIconSize.sm;
      case FabSize.large:
        return AppIconSize.lg;
    }
  }

  Color _getBackgroundColor() {
    if (isDisabled) {
      return theme == FabTheme.light
          ? AppColors.neutral300
          : AppColors.neutral700;
    }

    switch (variant) {
      case FabVariant.primary:
        return AppColors.primary500;
      case FabVariant.secondary:
        return theme == FabTheme.light
            ? AppColors.neutral100
            : AppColors.neutral800;
    }
  }

  Color _getIconColor() {
    if (isDisabled) {
      return AppColors.neutral500;
    }

    switch (variant) {
      case FabVariant.primary:
        return AppColors.neutral000;
      case FabVariant.secondary:
        return theme == FabTheme.light
            ? AppColors.primary500
            : AppColors.primary500;
    }
  }
}

/// FAB variant styles
enum FabVariant { primary, secondary }

/// FAB size options
enum FabSize { small, large }

/// FAB theme (Light or Dark mode)
enum FabTheme { light, dark }
