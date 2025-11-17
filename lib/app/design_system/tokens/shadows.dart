// lib/app/design_system/tokens/shadows.dart
import 'package:flutter/material.dart';

class AppShadows {
  // Private constructor to prevent instantiation
  AppShadows._();

  // Shadow color with opacity
  static const Color _shadowColor = Color(0xFF333333);

  // ========== SHADOW PRESETS ==========

  /// Shadow Small (shadow-sm)
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.05),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  /// Shadow Medium (shadow-md)
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.08),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.04),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  /// Shadow Large (shadow-lg)
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.10),
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.05),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  /// Shadow Extra Large (shadow-xl)
  static List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.10),
      offset: const Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.04),
      offset: const Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];

  // ========== HELPER METHODS ==========

  /// Create custom shadow with specific parameters
  static List<BoxShadow> custom({
    required double offsetX,
    required double offsetY,
    required double blurRadius,
    double spreadRadius = 0,
    Color? color,
    double opacity = 0.1,
  }) {
    return [
      BoxShadow(
        color: (color ?? _shadowColor).withValues(alpha: opacity),
        offset: Offset(offsetX, offsetY),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    ];
  }

  /// No shadow (useful for conditionally removing shadows)
  static List<BoxShadow> get none => [];
}
