// lib/app/design_system/tokens/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========== WARNING COLORS ==========
  static const Color warning100 = Color(0xFFF7F2DF);
  static const Color warning300 = Color(0xFFF2D679);
  static const Color warning500 = Color(0xFFE5B61A);
  static const Color warning700 = Color(0xFF99790F);
  static const Color warning900 = Color(0xFF4D4C08);

  // ========== PRIMARY COLORS ==========
  static const Color primary100 = Color(0xFFECF7DF);
  static const Color primary300 = Color(0xFFC0E595);
  static const Color primary500 = Color(0xFF8CC540);
  static const Color primary700 = Color(0xFF588C1C);
  static const Color primary900 = Color(0xFF2C4D08);

  // ========== SUCCESS COLORS ==========
  static const Color success100 = Color(0xFFECF7DF);
  static const Color success300 = Color(0xFFC0E595);
  static const Color success500 = Color(0xFF8CC540);
  static const Color success700 = Color(0xFF588C1C);
  static const Color success900 = Color(0xFF2C4D08);

  // ========== NEUTRAL COLORS ==========
  static const Color neutral000 = Color(0xFFFFFFFF);
  static const Color neutral100 = Color(0xFFF2F2F2);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral500 = Color(0xFFBDBDBD);
  static const Color neutral700 = Color(0xFF818285);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF333333);

  // ========== ERROR COLORS ==========
  static const Color error100 = Color(0xFFB45151);
  static const Color error300 = Color(0xFFB45151);
  static const Color error500 = Color(0xFFB45151);
  static const Color error700 = Color(0xFFB45151);
  static const Color error900 = Color(0xFFB45151);

  // ========== SEMANTIC COLORS ==========
  // Default primary color for branding
  static const Color primaryDefault = primary500;

  // Background colors
  static const Color backgroundLight = neutral000;
  static const Color backgroundDark = neutral900;

  // Card background colors
  static const Color cardBackgroundLight = neutral000;
  static const Color cardBackgroundDark = neutral800;

  // Divider colors
  static const Color dividerLight = neutral300;
  static const Color dividerDark = neutral700;

  // Text colors
  static const Color textLight = neutral900;
  static const Color textDark = neutral100;

  // Text secondary colors
  static const Color textSecondaryLight = neutral700;
  static const Color textSecondaryDark = neutral500;

  // Button container colors
  static const Color buttonContainerLight = primary500;
  static const Color buttonContainerDark = primary300;

  // Button label colors
  static const Color buttonLabelLight = neutral000;
  static const Color buttonLabelDark = neutral800;

  // Status colors (for badges, chips, etc.)
  static const Color statusLight = neutral700;
  static const Color statusDark = neutral300;

  // Default border colors
  static const Color borderDefault = neutral300;
  static const Color borderFocused = primary500;
  static const Color borderError = error500;

  // ========== COLOR SCHEMES ==========
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: buttonContainerLight,
    onPrimary: buttonLabelLight,
    secondary: primary700,
    onSecondary: neutral000,
    error: error500,
    onError: neutral000,
    surface: backgroundLight,
    onSurface: textLight,
    surfaceContainerHighest: cardBackgroundLight,
    outline: dividerLight,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: buttonContainerDark,
    onPrimary: buttonLabelDark,
    secondary: primary500,
    onSecondary: neutral000,
    error: error300,
    onError: neutral900,
    surface: backgroundDark,
    onSurface: textDark,
    surfaceContainerHighest: cardBackgroundDark,
    outline: dividerDark,
  );
}
