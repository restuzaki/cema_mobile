// lib/app/design_system/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../design_system.dart';

/// Custom button widget with multiple variants and states
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonTheme theme;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.theme = CustomButtonTheme.light,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(isDisabled),
          foregroundColor: _getTextColor(isDisabled),
          disabledBackgroundColor: _getDisabledBackgroundColor(),
          disabledForegroundColor: _getDisabledTextColor(),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: _getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusFull,
            side: variant == ButtonVariant.secondary
                ? BorderSide(color: _getBorderColor(isDisabled), width: 1)
                : BorderSide.none,
          ),
          textStyle: _getTextStyle(),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(false)),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.xs,
        children: [
          Text(text),
          Icon(icon, size: _getIconSize()),
        ],
      );
    }

    return Text(text);
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        );
      case ButtonSize.medium:
        return AppSpacing.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        );
      case ButtonSize.large:
        return AppSpacing.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.labelSmall;
      case ButtonSize.medium:
      case ButtonSize.large:
        return AppTypography.bodyLG;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppIconSize.sm;
      case ButtonSize.medium:
      case ButtonSize.large:
        return AppIconSize.md;
    }
  }

  Color _getBackgroundColor(bool isDisabled) {
    if (isDisabled) return _getDisabledBackgroundColor();

    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.primary500;
      case ButtonVariant.secondary:
        return AppColors.backgroundLight;
      case ButtonVariant.danger:
        return AppColors.error500;
      case ButtonVariant.warning:
        return AppColors.warning500;
      case ButtonVariant.noFill:
        return Colors.transparent;
    }
  }

  Color _getTextColor(bool isDisabled) {
    if (isDisabled) return _getDisabledTextColor();

    final isLight = theme == CustomButtonTheme.light;

    switch (variant) {
      case ButtonVariant.primary:
        return isLight ? AppColors.neutral000 : AppColors.neutral900;
      case ButtonVariant.secondary:
        return isLight ? AppColors.neutral900 : AppColors.neutral000;
      case ButtonVariant.danger:
        return AppColors.neutral000;
      case ButtonVariant.warning:
        return AppColors.neutral000;
      case ButtonVariant.noFill:
        return isLight ? AppColors.primary700 : AppColors.neutral000;
    }
  }

  Color _getBorderColor(bool isDisabled) {
    if (isDisabled) return AppColors.neutral300;

    final isLight = theme == CustomButtonTheme.light;

    return isLight ? AppColors.neutral500 : AppColors.neutral700;
  }

  Color _getDisabledBackgroundColor() {
    final isLight = theme == CustomButtonTheme.light;

    if (variant == ButtonVariant.secondary) {
      return Colors.transparent;
    }

    return isLight ? AppColors.neutral300 : AppColors.neutral700;
  }

  Color _getDisabledTextColor() {
    final isLight = theme == CustomButtonTheme.light;
    return isLight ? AppColors.neutral500 : AppColors.neutral500;
  }
}

/// Button theme (Light or Dark mode)
enum CustomButtonTheme { light, dark }

/// Button variant styles
enum ButtonVariant { primary, secondary, danger, warning, noFill }

/// Button size options
enum ButtonSize { small, medium, large }
