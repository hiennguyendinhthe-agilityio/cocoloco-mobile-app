import 'package:flutter/material.dart';

import 'app_primitives.dart';

class CocolocoCustomTheme extends ThemeExtension<CocolocoCustomTheme> {
  final Color cappuccinoPink;
  final Color croissantBlue;
  final Color americanoOrange;
  final Color matchaGreen;
  final Color berryViolet;
  final Color priceMuted;
  final Color navActiveCircle;
  final Color navInactive;
  final Color cartButtonBg;
  final Color cartButtonIcon;
  final Color shadowCard;
  final Color statusConfirmedBg;
  final Color statusConfirmedText;
  final Color statusCompletedBg;
  final Color statusCompletedText;
  final Color statusCancelledBg;
  final Color statusCancelledText;
  final Color statusPendingBg;
  final Color statusPendingText;

  const CocolocoCustomTheme({
    required this.cappuccinoPink,
    required this.croissantBlue,
    required this.americanoOrange,
    required this.matchaGreen,
    required this.berryViolet,
    required this.priceMuted,
    required this.navActiveCircle,
    required this.navInactive,
    required this.cartButtonBg,
    required this.cartButtonIcon,
    required this.shadowCard,
    required this.statusConfirmedBg,
    required this.statusConfirmedText,
    required this.statusCompletedBg,
    required this.statusCompletedText,
    required this.statusCancelledBg,
    required this.statusCancelledText,
    required this.statusPendingBg,
    required this.statusPendingText,
  });

  static const CocolocoCustomTheme light = CocolocoCustomTheme(
    cappuccinoPink: AppPalette.coralRose,
    croissantBlue: AppPalette.periwinkleBlue,
    americanoOrange: AppPalette.amberOrange,
    matchaGreen: AppPalette.forestGreen,
    berryViolet: AppPalette.mulberryWine,
    priceMuted: AppPalette.slate400,
    navActiveCircle: AppPalette.burgundy500,
    navInactive: AppPalette.taupe300,
    cartButtonBg: AppPalette.pureWhite,
    cartButtonIcon: AppPalette.burgundy700,
    shadowCard: AppPalette.burgundy100,
    statusConfirmedBg: AppPalette.statusConfirmedBg,
    statusConfirmedText: AppPalette.statusConfirmedText,
    statusCompletedBg: AppPalette.statusCompletedBg,
    statusCompletedText: AppPalette.statusCompletedText,
    statusCancelledBg: AppPalette.statusCancelledBg,
    statusCancelledText: AppPalette.statusCancelledText,
    statusPendingBg: AppPalette.statusPendingBg,
    statusPendingText: AppPalette.statusPendingText,
  );

  static const CocolocoCustomTheme dark = CocolocoCustomTheme(
    cappuccinoPink: AppPalette.coralRose,
    croissantBlue: AppPalette.periwinkleBlue,
    americanoOrange: AppPalette.amberOrange,
    matchaGreen: AppPalette.forestGreen,
    berryViolet: AppPalette.mulberryWine,
    priceMuted: AppPalette.slate400,
    navActiveCircle: AppPalette.darkPrimary,
    navInactive: AppPalette.taupe500,
    cartButtonBg: AppPalette.darkSurfaceElevated,
    cartButtonIcon: AppPalette.darkPrimary,
    shadowCard: Color(0x33000000),
    statusConfirmedBg: Color(0xFF1E3A5F),
    statusConfirmedText: Color(0xFF90CDF4),
    statusCompletedBg: Color(0xFF1C4522),
    statusCompletedText: Color(0xFF9AE6B4),
    statusCancelledBg: Color(0xFF4A1D1D),
    statusCancelledText: Color(0xFFFEB2B2),
    statusPendingBg: Color(0xFF4D3800),
    statusPendingText: Color(0xFFFBD38D),
  );

  @override
  CocolocoCustomTheme copyWith({
    Color? cappuccinoPink,
    Color? croissantBlue,
    Color? americanoOrange,
    Color? matchaGreen,
    Color? berryViolet,
    Color? priceMuted,
    Color? navActiveCircle,
    Color? navInactive,
    Color? cartButtonBg,
    Color? cartButtonIcon,
    Color? shadowCard,
    Color? statusConfirmedBg,
    Color? statusConfirmedText,
    Color? statusCompletedBg,
    Color? statusCompletedText,
    Color? statusCancelledBg,
    Color? statusCancelledText,
    Color? statusPendingBg,
    Color? statusPendingText,
  }) {
    return CocolocoCustomTheme(
      cappuccinoPink: cappuccinoPink ?? this.cappuccinoPink,
      croissantBlue: croissantBlue ?? this.croissantBlue,
      americanoOrange: americanoOrange ?? this.americanoOrange,
      matchaGreen: matchaGreen ?? this.matchaGreen,
      berryViolet: berryViolet ?? this.berryViolet,
      priceMuted: priceMuted ?? this.priceMuted,
      navActiveCircle: navActiveCircle ?? this.navActiveCircle,
      navInactive: navInactive ?? this.navInactive,
      cartButtonBg: cartButtonBg ?? this.cartButtonBg,
      cartButtonIcon: cartButtonIcon ?? this.cartButtonIcon,
      shadowCard: shadowCard ?? this.shadowCard,
      statusConfirmedBg: statusConfirmedBg ?? this.statusConfirmedBg,
      statusConfirmedText: statusConfirmedText ?? this.statusConfirmedText,
      statusCompletedBg: statusCompletedBg ?? this.statusCompletedBg,
      statusCompletedText: statusCompletedText ?? this.statusCompletedText,
      statusCancelledBg: statusCancelledBg ?? this.statusCancelledBg,
      statusCancelledText: statusCancelledText ?? this.statusCancelledText,
      statusPendingBg: statusPendingBg ?? this.statusPendingBg,
      statusPendingText: statusPendingText ?? this.statusPendingText,
    );
  }

  @override
  CocolocoCustomTheme lerp(
    covariant ThemeExtension<CocolocoCustomTheme>? other,
    double t,
  ) {
    if (other is! CocolocoCustomTheme) return this;
    return CocolocoCustomTheme(
      cappuccinoPink: Color.lerp(cappuccinoPink, other.cappuccinoPink, t)!,
      croissantBlue: Color.lerp(croissantBlue, other.croissantBlue, t)!,
      americanoOrange: Color.lerp(americanoOrange, other.americanoOrange, t)!,
      matchaGreen: Color.lerp(matchaGreen, other.matchaGreen, t)!,
      berryViolet: Color.lerp(berryViolet, other.berryViolet, t)!,
      priceMuted: Color.lerp(priceMuted, other.priceMuted, t)!,
      navActiveCircle: Color.lerp(navActiveCircle, other.navActiveCircle, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
      cartButtonBg: Color.lerp(cartButtonBg, other.cartButtonBg, t)!,
      cartButtonIcon: Color.lerp(cartButtonIcon, other.cartButtonIcon, t)!,
      shadowCard: Color.lerp(shadowCard, other.shadowCard, t)!,
      statusConfirmedBg: Color.lerp(
        statusConfirmedBg,
        other.statusConfirmedBg,
        t,
      )!,
      statusConfirmedText: Color.lerp(
        statusConfirmedText,
        other.statusConfirmedText,
        t,
      )!,
      statusCompletedBg: Color.lerp(
        statusCompletedBg,
        other.statusCompletedBg,
        t,
      )!,
      statusCompletedText: Color.lerp(
        statusCompletedText,
        other.statusCompletedText,
        t,
      )!,
      statusCancelledBg: Color.lerp(
        statusCancelledBg,
        other.statusCancelledBg,
        t,
      )!,
      statusCancelledText: Color.lerp(
        statusCancelledText,
        other.statusCancelledText,
        t,
      )!,
      statusPendingBg: Color.lerp(statusPendingBg, other.statusPendingBg, t)!,
      statusPendingText: Color.lerp(
        statusPendingText,
        other.statusPendingText,
        t,
      )!,
    );
  }
}

extension CocolocoThemeContext on BuildContext {
  CocolocoCustomTheme get cocolocoTheme {
    return Theme.of(this).extension<CocolocoCustomTheme>() ??
        CocolocoCustomTheme.light;
  }
}
