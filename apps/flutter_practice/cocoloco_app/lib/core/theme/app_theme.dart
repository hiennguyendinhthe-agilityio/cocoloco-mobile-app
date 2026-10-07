import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens/app_primitives.dart';
import 'tokens/app_semantics.dart';
import 'tokens/cocoloco_theme_extension.dart';

export 'app_colors.dart';
export 'app_typography.dart';
export 'theme_context_extension.dart';
export 'tokens/app_primitives.dart';
export 'tokens/app_semantics.dart';
export 'tokens/cocoloco_theme_extension.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppSemanticTypography.fontFamily,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppSemanticColors.background,
      colorScheme: AppSemanticColors.lightColorScheme,
      textTheme: AppSemanticTypography.textTheme,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: AppSemanticColors.primary),
        titleTextStyle: AppSemanticTypography.headlineMedium,
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: AppSemanticColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xxl),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppSemanticColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          textStyle: AppSemanticTypography.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppSemanticColors.primary,
          side: const BorderSide(color: AppSemanticColors.primary, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          textStyle: AppSemanticTypography.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppSemanticColors.primary,
          textStyle: AppSemanticTypography.labelLarge,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppSemanticColors.surfaceMuted,
        selectedColor: AppSemanticColors.primary,
        disabledColor: AppPalette.cream100,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          side: const BorderSide(
            color: AppSemanticColors.borderSubtle,
            width: 1.2,
          ),
        ),
        labelStyle: AppSemanticTypography.bodyMedium,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppSemanticColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: const BorderSide(
            color: AppSemanticColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: const BorderSide(
            color: AppSemanticColors.error,
            width: 1.2,
          ),
        ),
        hintStyle: AppSemanticTypography.bodyMedium.copyWith(
          color: AppSemanticColors.textMuted,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppSemanticColors.background,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: AppPalette.taupe300,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppSemanticColors.surface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.hero),
        ),
        titleTextStyle: AppSemanticTypography.headlineLarge,
        contentTextStyle: AppSemanticTypography.bodyMedium,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppSemanticColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppSemanticColors.divider,
        thickness: 1,
        space: 1,
      ),

      extensions: const [CocolocoCustomTheme.light],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppSemanticTypography.fontFamily,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppPalette.darkBackground,
      colorScheme: AppSemanticColors.darkColorScheme,
      textTheme: AppSemanticTypography.darkTextTheme,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppPalette.darkPrimary),
        titleTextStyle: TextStyle(
          fontFamily: AppSemanticTypography.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: AppPalette.cream50,
          letterSpacing: -0.2,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: AppPalette.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xxl),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppPalette.darkPrimary,
          foregroundColor: AppPalette.espresso900,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          textStyle: AppSemanticTypography.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.darkPrimary,
          side: const BorderSide(color: AppPalette.darkBorder, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          textStyle: AppSemanticTypography.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.darkPrimary,
          textStyle: AppSemanticTypography.labelLarge,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppPalette.darkSurfaceElevated,
        selectedColor: AppPalette.darkPrimary,
        disabledColor: AppPalette.darkSurface,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          side: const BorderSide(color: AppPalette.darkBorder, width: 1.2),
        ),
        labelStyle: AppSemanticTypography.bodyMedium.copyWith(
          color: AppPalette.cream50,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.darkSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: const BorderSide(
            color: AppPalette.darkPrimary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: const BorderSide(
            color: AppPalette.crimsonRed,
            width: 1.2,
          ),
        ),
        hintStyle: AppSemanticTypography.bodyMedium.copyWith(
          color: AppPalette.taupe500,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppPalette.darkSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: AppPalette.taupe500,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppPalette.darkSurface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.hero),
        ),
        titleTextStyle: AppSemanticTypography.headlineLarge.copyWith(
          color: AppPalette.cream50,
        ),
        contentTextStyle: AppSemanticTypography.bodyMedium.copyWith(
          color: AppPalette.taupe300,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppPalette.darkSurfaceElevated,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        contentTextStyle: const TextStyle(
          color: AppPalette.cream50,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppPalette.darkDivider,
        thickness: 1,
        space: 1,
      ),

      extensions: const [CocolocoCustomTheme.dark],
    );
  }
}
