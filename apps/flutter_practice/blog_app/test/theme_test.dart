import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/core/providers/theme_mode_provider.dart';
import 'package:blog_app/core/theme/app_theme.dart';

void main() {
  group('Tier 1: Primitive Design Tokens Tests', () {
    test('AppPalette contains exact brand hex values', () {
      expect(AppPalette.burgundy800.toARGB32(), equals(0xFF5B1921));
      expect(AppPalette.burgundy900.toARGB32(), equals(0xFF3E0F15));
      expect(AppPalette.cream50.toARGB32(), equals(0xFFFFFEFA));
      expect(AppPalette.coralRose.toARGB32(), equals(0xFFD8555F));
      expect(AppPalette.periwinkleBlue.toARGB32(), equals(0xFF6479C3));
      expect(AppPalette.taupe300.toARGB32(), equals(0xFFB1AEA3));
      expect(AppPalette.taupe500.toARGB32(), equals(0xFF8E8B82));
    });

    test('AppSpacing scales strictly in ascending order', () {
      expect(AppSpacing.xs, lessThan(AppSpacing.sm));
      expect(AppSpacing.sm, lessThan(AppSpacing.md));
      expect(AppSpacing.md, lessThan(AppSpacing.lg));
      expect(AppSpacing.lg, lessThan(AppSpacing.xl));
      expect(AppSpacing.xl, lessThan(AppSpacing.xxl));
    });

    test('AppRadii scales strictly in ascending order', () {
      expect(AppRadii.xs, lessThan(AppRadii.sm));
      expect(AppRadii.sm, lessThan(AppRadii.md));
      expect(AppRadii.md, lessThan(AppRadii.lg));
      expect(AppRadii.lg, lessThan(AppRadii.cardHero));
      expect(AppRadii.cardHero, lessThan(AppRadii.pill));
    });

    test('AppShadows defined with realistic elevation offsets', () {
      expect(AppShadows.card.first.blurRadius, equals(16));
      expect(AppShadows.soft.isNotEmpty, isTrue);
      expect(AppShadows.hero.isNotEmpty, isTrue);
      expect(AppShadows.brandSubtle.isNotEmpty, isTrue);
    });

    test('Order status tokens match specifications', () {
      expect(AppPalette.statusConfirmedBg.toARGB32(), equals(0xFFE8F1FC));
      expect(AppPalette.statusCompletedBg.toARGB32(), equals(0xFFEAF8ED));
      expect(AppPalette.statusCancelledBg.toARGB32(), equals(0xFFFDEEEC));
      expect(AppPalette.statusPendingBg.toARGB32(), equals(0xFFFFF7E6));
    });
  });

  group('Tier 2: Semantic Design Tokens Tests', () {
    test('AppSemanticColors maps primitives to semantic roles', () {
      expect(AppSemanticColors.primary, equals(AppPalette.burgundy800));
      expect(AppSemanticColors.background, equals(AppPalette.cream50));
      expect(AppSemanticColors.surface, equals(AppPalette.pureWhite));
      expect(AppSemanticColors.textPrimary, equals(AppPalette.espresso900));
      expect(AppSemanticColors.textSecondary, equals(AppPalette.taupe500));
      expect(AppSemanticColors.borderSubtle, equals(AppPalette.cream200));
    });

    test('ColorScheme matches Material 3 standard', () {
      final scheme = AppSemanticColors.lightColorScheme;
      expect(scheme.primary, equals(AppSemanticColors.primary));
      expect(scheme.surface, equals(AppSemanticColors.surface));
      expect(scheme.onPrimary, equals(AppPalette.pureWhite));
      expect(scheme.error, equals(AppPalette.crimsonRed));
      expect(scheme.onSurfaceVariant, equals(AppSemanticColors.textSecondary));

      final darkScheme = AppSemanticColors.darkColorScheme;
      expect(darkScheme.primary, equals(AppPalette.darkPrimary));
      expect(darkScheme.surface, equals(AppPalette.darkSurface));
      expect(darkScheme.onSurfaceVariant, equals(AppPalette.taupe300));
    });

    test('AppSemanticTypography uses Chap font and correct scale', () {
      expect(AppSemanticTypography.fontFamily, equals('Chap'));
      expect(AppSemanticTypography.headlineLarge.fontSize, equals(24));
      expect(AppSemanticTypography.headlineMedium.fontSize, equals(20));
      expect(AppSemanticTypography.bodyLarge.fontSize, equals(16));
      expect(AppSemanticTypography.bodyMedium.fontSize, equals(14));
      expect(AppSemanticTypography.caption.fontSize, equals(12));
    });
  });

  group('Tier 3: Component Themes & ThemeExtension Tests', () {
    final theme = AppTheme.lightTheme;

    test('AppTheme configures all core component themes', () {
      expect(theme.useMaterial3, isTrue);
      expect(theme.scaffoldBackgroundColor, equals(AppSemanticColors.background));
      expect(theme.cardTheme.elevation, equals(0));
      expect(theme.elevatedButtonTheme.style, isNotNull);
      expect(theme.outlinedButtonTheme.style, isNotNull);
      expect(theme.chipTheme.backgroundColor, equals(AppSemanticColors.surfaceMuted));
      expect(theme.inputDecorationTheme.filled, isTrue);
      expect(theme.bottomSheetTheme.showDragHandle, isTrue);
      expect(theme.snackBarTheme.behavior, equals(SnackBarBehavior.floating));
    });

    test('CocolocoCustomTheme ThemeExtension registered and accessible', () {
      final customTheme = theme.extension<CocolocoCustomTheme>();
      expect(customTheme, isNotNull);
      expect(customTheme!.cappuccinoPink, equals(AppPalette.coralRose));
      expect(customTheme.croissantBlue, equals(AppPalette.periwinkleBlue));
      expect(customTheme.americanoOrange, equals(AppPalette.amberOrange));
      expect(customTheme.matchaGreen, equals(AppPalette.forestGreen));
      expect(customTheme.navActiveCircle, equals(AppPalette.burgundy500));
      expect(customTheme.navInactive, equals(AppPalette.taupe300));
      expect(customTheme.cartButtonBg, equals(AppPalette.pureWhite));
      expect(customTheme.cartButtonIcon, equals(AppPalette.burgundy700));
    });

    test('CocolocoCustomTheme copyWith and lerp operate correctly', () {
      const original = CocolocoCustomTheme.light;
      final copied = original.copyWith(cappuccinoPink: Colors.pink);
      expect(copied.cappuccinoPink, equals(Colors.pink));
      expect(copied.croissantBlue, equals(original.croissantBlue));

      final lerped = original.lerp(copied, 0.5);
      expect(lerped, isNotNull);
    });

    test('AppTheme.darkTheme configures dark mode and dark theme extension', () {
      final dark = AppTheme.darkTheme;
      expect(dark.useMaterial3, isTrue);
      expect(dark.brightness, equals(Brightness.dark));
      expect(dark.scaffoldBackgroundColor, equals(AppPalette.darkBackground));
      expect(dark.colorScheme.brightness, equals(Brightness.dark));
      expect(dark.colorScheme.surface, equals(AppPalette.darkSurface));

      final customDark = dark.extension<CocolocoCustomTheme>();
      expect(customDark, isNotNull);
      expect(customDark!.navActiveCircle, equals(AppPalette.darkPrimary));
      expect(customDark.cartButtonBg, equals(AppPalette.darkSurfaceElevated));
    });

    testWidgets('context.cocolocoTheme retrieves custom tokens inside widget tree',
        (tester) async {
      Color? retrievedColor;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              retrievedColor = context.cocolocoTheme.cappuccinoPink;
              return Container(color: retrievedColor);
            },
          ),
        ),
      );

      expect(retrievedColor, equals(AppPalette.coralRose));
    });
  });

  group('ThemeMode State Management Tests', () {
    test('ThemeModeNotifier toggles between light and dark correctly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), equals(ThemeMode.system));

      final notifier = container.read(themeModeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), equals(ThemeMode.light));

      await notifier.toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));

      await notifier.toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.light));
    });
  });

  group('Façade Backward Compatibility Layer Tests', () {
    test('AppColors façade preserves 100% exact ARGB values', () {
      expect(AppColors.primary.toARGB32(), equals(0xFF5B1921));
      expect(AppColors.primaryDark.toARGB32(), equals(0xFF3E0F15));
      expect(AppColors.background.toARGB32(), equals(0xFFFFFEFA));
      expect(AppColors.surface.toARGB32(), equals(0xFFFFFFFF));
      expect(AppColors.cappuccinoPink.toARGB32(), equals(0xFFD8555F));
      expect(AppColors.croissantBlue.toARGB32(), equals(0xFF6479C3));
      expect(AppColors.navActiveCircle.toARGB32(), equals(0xFF95545C));
      expect(AppColors.navInactive.toARGB32(), equals(0xFFB1AEA3));
    });

    test('AppTypography façade delegates to semantic typography', () {
      expect(AppTypography.fontFamily, equals('Chap'));
      expect(AppTypography.headingLarge.fontSize, equals(24));
      expect(AppTypography.sectionHeading.fontSize, equals(20));
      expect(AppTypography.bodyLarge.fontSize, equals(16));
      expect(AppTypography.productTitle(Colors.black).fontFamily, equals('Chap'));
    });

    test('AppTheme.darkTheme has darkTextTheme headlineMedium color', () {
      expect(AppTheme.darkTheme.textTheme.headlineMedium?.color, equals(AppPalette.darkPrimary));
    });

    testWidgets('AppTypography context-aware methods adapt to Light and Dark modes',
        (tester) async {
      TextStyle? lightHeading;
      TextStyle? darkHeading;

      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: AppTheme.lightTheme,
            child: Builder(
              builder: (context) {
                lightHeading = AppTypography.sectionHeadingOf(context);
                return Container();
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: AppTheme.darkTheme,
            child: Builder(
              builder: (context) {
                darkHeading = AppTypography.sectionHeadingOf(context);
                return Container();
              },
            ),
          ),
        ),
      );

      expect(lightHeading?.color, equals(AppSemanticColors.primary));
      expect(darkHeading?.color, equals(AppPalette.darkPrimary));
    });

    testWidgets('ElevatedButton can be placed in unconstrained horizontal Row without BoxConstraints crash',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: Scaffold(
            body: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Test Safe Button'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Safe Button'), findsOneWidget);
    });
  });
}
