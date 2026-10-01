import 'package:flutter/material.dart';
import 'tokens/cocoloco_theme_extension.dart';

/// Extension tiện lợi trên BuildContext để truy xuất Theme nhanh gọn
extension ThemeContextExtension on BuildContext {
  /// Truy xuất ThemeData hiện tại
  ThemeData get theme => Theme.of(this);

  /// Truy xuất ColorScheme ngữ nghĩa (Tier 2)
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Truy xuất TextTheme chuẩn (Tier 2)
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Truy xuất Domain ThemeExtension riêng của Cocoloco (Tier 3)
  CocolocoCustomTheme get cocolocoColors =>
      Theme.of(this).extension<CocolocoCustomTheme>() ??
      CocolocoCustomTheme.light;
}
