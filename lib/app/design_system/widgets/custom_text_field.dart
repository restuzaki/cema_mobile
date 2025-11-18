// lib/app/design_system/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../design_system.dart';

/// Custom text field widget with design system integration
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String? errorText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextFieldState state;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.label,
    this.placeholder,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onTap,
    this.state = TextFieldState.defaultState,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.bodySM.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          style: AppTypography.bodyMD.copyWith(
            color: enabled ? AppColors.textLight : AppColors.textSecondaryLight,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTypography.bodyMD.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: _getIconColor(), size: AppIconSize.md)
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      suffixIcon,
                      color: _getIconColor(),
                      size: AppIconSize.md,
                    ),
                    onPressed: onSuffixIconTap,
                  )
                : null,
            filled: true,
            fillColor: enabled
                ? AppColors.backgroundLight
                : AppColors.neutral300,
            contentPadding: AppSpacing.paddingMd,
            border: OutlineInputBorder(
              borderRadius: AppRadius.radiusMd,
              borderSide: BorderSide(color: _getBorderColor(), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusMd,
              borderSide: BorderSide(color: _getBorderColor(), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusMd,
              borderSide: BorderSide(color: _getFocusedBorderColor(), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusMd,
              borderSide: BorderSide(color: AppColors.error500, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusMd,
              borderSide: BorderSide(color: AppColors.error500, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusMd,
              borderSide: BorderSide(color: AppColors.neutral300, width: 1),
            ),
            errorText: errorText,
            errorStyle: AppTypography.bodySM.copyWith(
              color: AppColors.error500,
            ),
          ),
        ),
        if (hint != null) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            hint!,
            style: AppTypography.bodySM.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }

  Color _getBorderColor() {
    switch (state) {
      case TextFieldState.error:
        return AppColors.error500;
      case TextFieldState.focus:
        return AppColors.primary500;
      case TextFieldState.disabled:
        return AppColors.neutral300;
      case TextFieldState.defaultState:
        return AppColors.dividerLight;
    }
  }

  Color _getFocusedBorderColor() {
    if (state == TextFieldState.error) {
      return AppColors.error500;
    }
    return AppColors.primary500;
  }

  Color _getIconColor() {
    if (!enabled) return AppColors.neutral500;
    switch (state) {
      case TextFieldState.error:
        return AppColors.error500;
      case TextFieldState.focus:
        return AppColors.primary500;
      case TextFieldState.disabled:
        return AppColors.neutral500;
      case TextFieldState.defaultState:
        return AppColors.textSecondaryLight;
    }
  }
}

/// Text field state types
enum TextFieldState { defaultState, focus, error, disabled }
