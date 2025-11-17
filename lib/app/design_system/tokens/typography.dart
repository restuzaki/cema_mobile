// lib/app/design_system/tokens/typography.dart
import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  // Font family
  static const String fontFamily = 'Poppins';

  // ========== HEADING STYLES ==========

  /// Heading XL - 32px, SemiBold
  static const TextStyle headingXL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.5,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  /// Heading LG - 24px, SemiBold
  static const TextStyle headingLG = TextStyle(
    fontFamily: fontFamily,
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  /// Heading MD - 20px, SemiBold
  static const TextStyle headingMD = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  // ========== BODY STYLES ==========

  /// Body LG - 16px, Regular
  static const TextStyle bodyLG = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  /// Body MD - 16px, Regular
  static const TextStyle bodyMD = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body SM - 12px, Regular
  static const TextStyle bodySM = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.8,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ========== LABEL STYLES ==========

  /// Label Small - 12px, Medium
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.8,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // ========== TEXT THEME ==========

  /// Light theme typography
  static TextTheme lightTextTheme = const TextTheme(
    // Display styles
    displayLarge: headingXL,
    displayMedium: headingLG,
    displaySmall: headingMD,

    // Headline styles
    headlineLarge: headingXL,
    headlineMedium: headingLG,
    headlineSmall: headingMD,

    // Body styles
    bodyLarge: bodyLG,
    bodyMedium: bodyMD,
    bodySmall: bodySM,

    // Label styles
    labelLarge: labelSmall,
    labelMedium: labelSmall,
    labelSmall: labelSmall,
  );

  /// Dark theme typography (same as light theme)
  static TextTheme darkTextTheme = lightTextTheme;

  // ========== HELPER METHODS ==========

  /// Apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
}
