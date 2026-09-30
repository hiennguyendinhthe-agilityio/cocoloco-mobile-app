import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  // Family name registered in pubspec.yaml
  static const String fontFamily = 'Chap';

  // Primary Large Heading ("Your Orders", "Account & Role")
  static TextStyle get headingLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.primary,
        letterSpacing: -0.3,
      );

  // Primary Headings ("Let's get this day going", "April special")
  // Figma spec: Font Chap, Weight 900
  static TextStyle get sectionHeading => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AppColors.primary,
        letterSpacing: -0.2,
      );

  // Product Card Title ("Cappuccino", "Crossaint") - Exact Figma Card Vertical Spec:
  // Font: Chap, Weight: 700, Size: 20px, Line height: 100% (1.0), Letter spacing: 0%
  static TextStyle productTitle(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0,
        color: color,
      );

  // Product Card Price ("$3") - Muted Slate (#A5B1BC)
  static TextStyle get productPrice => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
        color: AppColors.priceMuted,
      );

  // Promo Banner Title ("BREAKFAST BUNDLE")
  static TextStyle get bannerTitle => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        height: 1.15,
        letterSpacing: 0.8,
      );

  // General Body Texts
  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );
}
