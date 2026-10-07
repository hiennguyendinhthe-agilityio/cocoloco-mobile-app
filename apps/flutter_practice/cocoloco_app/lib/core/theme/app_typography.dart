import 'package:flutter/material.dart';

import 'tokens/app_primitives.dart';
import 'tokens/app_semantics.dart';

abstract final class AppTypography {
  static const String fontFamily = AppSemanticTypography.fontFamily;

  static TextStyle get headingLarge => AppSemanticTypography.headlineLarge;
  static TextStyle headingLargeOf(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge ??
      AppSemanticTypography.headlineLarge;

  static TextStyle get sectionHeading => AppSemanticTypography.headlineMedium;
  static TextStyle sectionHeadingOf(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium ??
      AppSemanticTypography.headlineMedium;

  static TextStyle productTitle(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
    color: color,
  );

  static TextStyle get productPrice => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: AppPalette.slate400,
  );

  static TextStyle get bannerTitle => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    height: 1.15,
    letterSpacing: 0.8,
  );

  static TextStyle get bodyLarge => AppSemanticTypography.bodyLarge;
  static TextStyle get bodyMedium => AppSemanticTypography.bodyMedium;
  static TextStyle get caption => AppSemanticTypography.caption;
}
