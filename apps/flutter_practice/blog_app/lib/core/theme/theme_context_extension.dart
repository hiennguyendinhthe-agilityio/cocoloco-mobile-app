import 'package:flutter/material.dart';

import 'tokens/cocoloco_theme_extension.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  CocolocoCustomTheme get cocolocoColors =>
      Theme.of(this).extension<CocolocoCustomTheme>() ??
      CocolocoCustomTheme.light;
}
