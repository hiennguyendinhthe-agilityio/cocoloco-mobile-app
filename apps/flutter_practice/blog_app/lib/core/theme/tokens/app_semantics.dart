import 'package:flutter/material.dart';

import 'app_primitives.dart';

abstract final class AppSemanticColors {
  static const Color primary = AppPalette.burgundy800;
  static const Color primaryDark = AppPalette.burgundy900;
  static const Color primaryLight = AppPalette.burgundy600;

  static const Color background = AppPalette.cream50;
  static const Color surface = AppPalette.pureWhite;
  static const Color surfaceMuted = AppPalette.cream100;
  static const Color borderSubtle = AppPalette.cream200;
  static const Color divider = AppPalette.cream300;

  static const Color textPrimary = AppPalette.espresso900;
  static const Color textSecondary = AppPalette.taupe500;
  static const Color textMuted = AppPalette.taupe300;
  static const Color textOnPrimary = AppPalette.pureWhite;

  static const Color success = AppPalette.emeraldGreen;
  static const Color error = AppPalette.crimsonRed;
  static const Color warning = AppPalette.honeyAmber;
  static const Color info = AppPalette.infoBlue;

  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: primary,
    onPrimary: textOnPrimary,
    primaryContainer: primaryLight,
    onPrimaryContainer: textOnPrimary,
    surface: surface,
    onSurface: textPrimary,
    onSurfaceVariant: textSecondary,
    surfaceContainerHighest: surfaceMuted,
    outline: borderSubtle,
    outlineVariant: divider,
    error: error,
    onError: textOnPrimary,
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: AppPalette.darkPrimary,
    onPrimary: AppPalette.darkBackground,
    primaryContainer: AppPalette.burgundy800,
    onPrimaryContainer: AppPalette.cream50,
    surface: AppPalette.darkSurface,
    onSurface: AppPalette.cream50,
    onSurfaceVariant: AppPalette.taupe300,
    surfaceContainerHighest: AppPalette.darkSurfaceElevated,
    outline: AppPalette.darkBorder,
    outlineVariant: AppPalette.darkDivider,
    error: AppPalette.crimsonRed,
    onError: AppPalette.pureWhite,
  );
}

abstract final class AppSemanticTypography {
  static const String fontFamily = 'Chap';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppSemanticColors.primary,
    letterSpacing: -0.4,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: AppSemanticColors.primary,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppSemanticColors.primary,
    letterSpacing: -0.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppSemanticColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppSemanticColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppSemanticColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppSemanticColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppSemanticColors.textSecondary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: caption,
    labelLarge: labelLarge,
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: displayLarge.copyWith(color: AppPalette.darkPrimary),
    headlineLarge: headlineLarge.copyWith(color: AppPalette.darkPrimary),
    headlineMedium: headlineMedium.copyWith(color: AppPalette.darkPrimary),
    titleLarge: titleLarge.copyWith(color: AppPalette.cream50),
    titleMedium: titleMedium.copyWith(color: AppPalette.cream50),
    bodyLarge: bodyLarge.copyWith(color: AppPalette.cream50),
    bodyMedium: bodyMedium.copyWith(color: AppPalette.taupe300),
    bodySmall: caption.copyWith(color: AppPalette.taupe300),
    labelLarge: labelLarge.copyWith(color: AppPalette.cream50),
  );
}
