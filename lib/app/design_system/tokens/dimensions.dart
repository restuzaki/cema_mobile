// lib/app/design_system/tokens/dimensions.dart
import 'package:flutter/material.dart';

/// Border Radius tokens
class AppRadius {
  AppRadius._();

  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 16.0;
  static const double full = 9999.0;

  static BorderRadius get radiusSm => BorderRadius.circular(sm);
  static BorderRadius get radiusMd => BorderRadius.circular(md);
  static BorderRadius get radiusLg => BorderRadius.circular(lg);
  static BorderRadius get radiusFull => BorderRadius.circular(full);

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}

/// Spacing tokens
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static EdgeInsets get paddingXxs => EdgeInsets.all(xxs);
  static EdgeInsets get paddingXs => EdgeInsets.all(xs);
  static EdgeInsets get paddingSm => EdgeInsets.all(sm);
  static EdgeInsets get paddingMd => EdgeInsets.all(md);
  static EdgeInsets get paddingLg => EdgeInsets.all(lg);
  static EdgeInsets get paddingXl => EdgeInsets.all(xl);
  static EdgeInsets get paddingXxl => EdgeInsets.all(xxl);

  static Widget get gapXxs => SizedBox(width: xxs, height: xxs);
  static Widget get gapXs => SizedBox(width: xs, height: xs);
  static Widget get gapSm => SizedBox(width: sm, height: sm);
  static Widget get gapMd => SizedBox(width: md, height: md);
  static Widget get gapLg => SizedBox(width: lg, height: lg);
  static Widget get gapXl => SizedBox(width: xl, height: xl);
  static Widget get gapXxl => SizedBox(width: xxl, height: xxl);

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }

  static Widget horizontal(double width) => SizedBox(width: width);
  static Widget vertical(double height) => SizedBox(height: height);
}

/// Icon size tokens
class AppIconSize {
  AppIconSize._();

  /// Icon size small - 16px
  static const double sm = 16.0;

  /// Icon size medium - 24px
  static const double md = 24.0;

  /// Icon size large - 32px
  static const double lg = 32.0;

  /// Icon stroke width - 2px
  static const double strokeWidth = 2.0;
}
