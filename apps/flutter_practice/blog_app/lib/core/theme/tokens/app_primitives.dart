import 'package:flutter/material.dart';

/// ============================================================================
/// TIER 1: GLOBAL / PRIMITIVE DESIGN TOKENS
/// ============================================================================
/// Định nghĩa các giá trị nguyên bản, thô (Raw values) độc lập ngữ cảnh.
/// Tuyệt đối không chứa ý nghĩa ngữ dụng hay mục đích hiển thị.
/// Gồm có: Palette màu, Thang Spacing, Bo góc Radii, và Thang Elevation/Shadows.
/// ============================================================================

abstract final class AppPalette {
  // ---------------------------------------------------------------------------
  // 1. Brand Burgundy Scale (Sắc Vang Đỏ Cocoloco)
  // ---------------------------------------------------------------------------
  static const Color burgundy900 = Color(0xFF3E0F15); // Deep wine dark
  static const Color burgundy800 = Color(0xFF5B1921); // Core Brand Burgundy
  static const Color burgundy700 = Color(0xFF7A2935); // Accent rich red
  static const Color burgundy600 = Color(0xFF7E2A34); // Medium Burgundy
  static const Color burgundy500 = Color(0xFF95545C); // Dusty Plum Burgundy
  static const Color burgundy100 = Color(0x105B1921); // Subtle burgundy tint

  // ---------------------------------------------------------------------------
  // 2. Warm Neutrals & Surface Scale (Sắc Độ Hạt Cà Phê, Kem & Giấy Mộc)
  // ---------------------------------------------------------------------------
  static const Color cream50 = Color(0xFFFFFEFA); // Warm Off-White Cream
  static const Color neutralMuted50 = Color(0x80D9D4CE); // #D9D4CE 50% (Figma Background / Shadow)
  static const Color cream100 = Color(0x80D9D4CE); // Muted Oatmeal / Surface Muted (#D9D4CE 50%)
  static const Color cream200 = Color(0xFFECE7DE); // Light Biscuit Border
  static const Color cream300 = Color(0xFFF1EBE3); // Card Divider

  static const Color taupe300 = Color(0xFFB1AEA3); // Warm Taupe Inactive
  static const Color taupe500 = Color(0xFF8E8B82); // Secondary Body Taupe
  static const Color slate400 = Color(0xFFA5B1BC); // Muted Slate Price Gray

  static const Color espresso900 = Color(0xFF260D11); // Deep Roasted Espresso Text
  static const Color textDark = espresso900; // Semantic text dark alias
  static const Color pureWhite = Color(0xFFFFFFFF); // Pure Card White
  static const Color pureBlack = Color(0xFF000000); // Absolute Black

  // ---------------------------------------------------------------------------
  // 3. Artisanal Product Accent Scale (Sắc Độ Sản Phẩm & Món Nước)
  // ---------------------------------------------------------------------------
  static const Color coralRose = Color(0xFFD8555F); // Cappuccino Pink
  static const Color periwinkleBlue = Color(0xFF6479C3); // Croissant Blue
  static const Color amberOrange = Color(0xFFD97736); // Americano / Beans Orange
  static const Color forestGreen = Color(0xFF5E8B62); // Matcha Sage Green
  static const Color mulberryWine = Color(0xFFA55375); // Berry Violet

  // ---------------------------------------------------------------------------
  // 4. Functional & Feedback Scale
  // ---------------------------------------------------------------------------
  static const Color emeraldGreen = Color(0xFF2E7D32); // Success
  static const Color crimsonRed = Color(0xFFD32F2F); // Error / Danger
  static const Color honeyAmber = Color(0xFFFFA000); // Warning
  static const Color infoBlue = Color(0xFF1976D2); // Info
  static const Color clerkPurple = Color(0xFF6C47FF); // Clerk Brand Purple

  // ---------------------------------------------------------------------------
  // 5. Order Status Pill Badges
  // ---------------------------------------------------------------------------
  static const Color statusConfirmedBg = Color(0xFFE8F1FC);
  static const Color statusConfirmedText = Color(0xFF2B6CB0);
  static const Color statusCompletedBg = Color(0xFFEAF8ED);
  static const Color statusCompletedText = Color(0xFF2E7D32);
  static const Color statusCancelledBg = Color(0xFFFDEEEC);
  static const Color statusCancelledText = Color(0xFFC53030);
  static const Color statusPendingBg = Color(0xFFFFF7E6);
  static const Color statusPendingText = Color(0xFFD97706);

  // ---------------------------------------------------------------------------
  // 6. Dark Theme Scale (Sắc Độ Cà Phê Về Đêm / Espresso Night Dark Mode)
  // ---------------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF141211); // Deep Espresso Dark Background
  static const Color darkSurface = Color(0xFF1E1B19); // Roasted Coffee Card Surface
  static const Color darkSurfaceElevated = Color(0xFF2C2825); // Elevated Dark Card / Pill
  static const Color darkBorder = Color(0xFF3D3733); // Dark Outline / Border
  static const Color darkDivider = Color(0xFF2E2926); // Dark Divider
  static const Color darkPrimary = Color(0xFFE56976); // High-contrast Rose Burgundy for Dark Surfaces
}

abstract final class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double section = 40.0;
}

abstract final class AppRadii {
  static const double xs = 6.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double cardInner = 22.0;
  static const double xxl = 24.0;
  static const double cardLg = 26.0;
  static const double hero = 28.0;
  static const double cardHero = 28.0;
  static const double sheet = 32.0;
  static const double pill = 999.0;
}

abstract final class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x80D9D4CE), // #D9D4CE 50% from Figma sjena spec
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> hero = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> brandSubtle = [
    BoxShadow(
      color: AppPalette.burgundy100,
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
  ];
}
