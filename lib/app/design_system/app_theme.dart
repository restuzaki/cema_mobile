// lib/app/design_system/app_theme.dart
import 'package:flutter/material.dart';
import 'tokens/colors.dart';
import 'tokens/typography.dart';
import 'tokens/shadows.dart';
import 'tokens/dimensions.dart';

/// Main theme configuration for the application
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      textTheme: AppTypography.lightTextTheme,
      fontFamily: AppTypography.fontFamily,

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardBackgroundLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        margin: EdgeInsets.all(AppSpacing.md),
      ),

      // Shadow Color for Material components
      shadowColor: AppColors.neutral900.withOpacity(0.1),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonContainerLight,
          foregroundColor: AppColors.buttonLabelLight,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          textStyle: AppTypography.labelSmall,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
      ),

      // Popup Menu Theme
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.backgroundLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
      ),

      // App Bar Theme with shadow
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: AppTypography.headingMD.copyWith(
          color: AppColors.textLight,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDefault,
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.labelSmall,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackgroundLight,
        contentPadding: AppSpacing.paddingMd,
        border: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.borderFocused, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.borderError),
        ),
        labelStyle: AppTypography.bodyMD.copyWith(
          color: AppColors.textSecondaryLight,
        ),
        hintStyle: AppTypography.bodyMD.copyWith(
          color: AppColors.textSecondaryLight,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textLight,
        size: AppIconSize.md,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundLight,
        selectedItemColor: AppColors.primaryDefault,
        unselectedItemColor: AppColors.textSecondaryLight,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.buttonContainerLight,
        foregroundColor: AppColors.buttonLabelLight,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      textTheme: AppTypography.darkTextTheme,
      fontFamily: AppTypography.fontFamily,

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardBackgroundDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        margin: EdgeInsets.all(AppSpacing.md),
      ),

      // Shadow Color for Material components
      shadowColor: AppColors.neutral000.withOpacity(0.1),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonContainerDark,
          foregroundColor: AppColors.buttonLabelDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          textStyle: AppTypography.labelSmall,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
      ),

      // Popup Menu Theme
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.backgroundDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
      ),

      // App Bar Theme with shadow
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: AppTypography.headingMD.copyWith(
          color: AppColors.textDark,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDefault,
          padding: AppSpacing.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.labelSmall,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackgroundDark,
        contentPadding: AppSpacing.paddingMd,
        border: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.dividerDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.borderFocused, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.borderError),
        ),
        labelStyle: AppTypography.bodyMD.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        hintStyle: AppTypography.bodyMD.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: AppColors.textDark, size: AppIconSize.md),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.primaryDefault,
        unselectedItemColor: AppColors.textSecondaryDark,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.buttonContainerDark,
        foregroundColor: AppColors.buttonLabelDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
      ),
    );
  }
}
