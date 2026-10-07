import 'package:flutter/material.dart';

import 'tokens/app_primitives.dart';
import 'tokens/app_semantics.dart';

abstract final class AppColors {
  static const Color primary = AppSemanticColors.primary;
  static const Color primaryDark = AppSemanticColors.primaryDark;
  static const Color primaryLight = AppSemanticColors.primaryLight;

  static const Color background = AppSemanticColors.background;
  static const Color surface = AppSemanticColors.surface;
  static const Color surfaceMuted = AppSemanticColors.surfaceMuted;

  static const Color cappuccinoPink = AppPalette.coralRose;
  static const Color croissantBlue = AppPalette.periwinkleBlue;
  static const Color americanoOrange = AppPalette.amberOrange;
  static const Color matchaGreen = AppPalette.forestGreen;
  static const Color berryViolet = AppPalette.mulberryWine;

  static const Color priceMuted = AppPalette.slate400;
  static const Color textSecondary = AppSemanticColors.textSecondary;
  static const Color textDark = AppSemanticColors.textPrimary;

  static const Color navActiveCircle = AppPalette.burgundy500;
  static const Color navInactive = AppPalette.taupe300;

  static const Color cartButtonBg = AppPalette.pureWhite;
  static const Color cartButtonIcon = AppPalette.burgundy700;

  static const Color shadow = Color(0x12000000);
  static const Color shadowCard = AppPalette.burgundy100;
}
