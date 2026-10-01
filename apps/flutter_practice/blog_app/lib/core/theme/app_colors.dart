import 'package:flutter/material.dart';
import 'tokens/app_primitives.dart';
import 'tokens/app_semantics.dart';

/// ============================================================================
/// FAÇADE: APP COLORS (BACKWARD COMPATIBILITY LAYER)
/// ============================================================================
/// Đóng vai trò là Façade trung gian trỏ về Tier 1 (Primitives) và Tier 2 (Semantics).
/// Giúp toàn bộ codebase hiện tại tiếp tục hoạt động mà không bị vỡ bất kỳ dòng nào.
/// ============================================================================

abstract final class AppColors {
  // Brand Burgundy Palette
  static const Color primary = AppSemanticColors.primary;
  static const Color primaryDark = AppSemanticColors.primaryDark;
  static const Color primaryLight = AppSemanticColors.primaryLight;

  // Background & Surfaces
  static const Color background = AppSemanticColors.background;
  static const Color surface = AppSemanticColors.surface;
  static const Color surfaceMuted = AppSemanticColors.surfaceMuted;

  // Product Specific Title Colors
  static const Color cappuccinoPink = AppPalette.coralRose;
  static const Color croissantBlue = AppPalette.periwinkleBlue;
  static const Color americanoOrange = AppPalette.amberOrange;
  static const Color matchaGreen = AppPalette.forestGreen;
  static const Color berryViolet = AppPalette.mulberryWine;

  // Price & Text Colors
  static const Color priceMuted = AppPalette.slate400;
  static const Color textSecondary = AppSemanticColors.textSecondary;
  static const Color textDark = AppSemanticColors.textPrimary;

  // Navigation Bar
  static const Color navActiveCircle = AppPalette.burgundy500;
  static const Color navInactive = AppPalette.taupe300;

  // Floating Shopping Cart Button
  static const Color cartButtonBg = AppPalette.pureWhite;
  static const Color cartButtonIcon = AppPalette.burgundy700;

  // Accents & Shadows
  static const Color shadow = Color(0x12000000);
  static const Color shadowCard = AppPalette.burgundy100;
}
