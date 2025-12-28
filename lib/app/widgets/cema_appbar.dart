import 'package:cema_mobile/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_leading_back_action.dart';

class CemaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;

  const CemaAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor = AppColors.backgroundLight,
    this.boxShadow,
  });

  static const double _verticalPadding = AppSpacing.md;
  static const double _horizontalPadding = AppSpacing.lg;
  static const double _gapBetweenText = AppSpacing.xxs;
  static const double _gapBetweenLeadingAndText = AppSpacing.md;
  static const double _gapBetweenActions = AppSpacing.md;

  static const TextStyle _titleStyle = AppTypography.headingLG;
  static const TextStyle _subtitleStyle = AppTypography.bodySM;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppRadius.lg),
            bottomRight: Radius.circular(AppRadius.lg),
          ),
          boxShadow: boxShadow ?? AppShadows.shadowMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: _gapBetweenLeadingAndText,
              children: [
                if (leading != null) leading!,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: _gapBetweenText,
                  children: [
                    Text(title, style: _titleStyle),
                    if (subtitle != null)
                      Text(subtitle!, style: _subtitleStyle),
                  ],
                ),
              ],
            ),
            if (actions != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: _gapBetweenActions,
                children: actions!,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    final double titleHeight =
        (_titleStyle.fontSize ?? 18) * (_titleStyle.height ?? 1.2);

    double subtitleHeight = 0;
    if (subtitle != null) {
      subtitleHeight =
          (_subtitleStyle.fontSize ?? 12) * (_subtitleStyle.height ?? 1.2);
      subtitleHeight += _gapBetweenText;
    }

    final double textContentHeight = titleHeight + subtitleHeight;

    final double contentHeight = textContentHeight > kToolbarHeight
        ? textContentHeight
        : kToolbarHeight;

    final double totalHeight = contentHeight + (AppSpacing.md * 2);

    return Size.fromHeight(totalHeight);
  }
}
