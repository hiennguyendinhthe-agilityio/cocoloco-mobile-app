library;

import 'package:bazar_books_design/core/resources/l10n_generated/l10n.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

extension ContextHelper on BuildContext {
  ThemeData get themeData => Theme.of(this);

  BazUiS get bazS => BazUiS.current;

  ColorScheme get colorScheme => themeData.colorScheme;

  TextTheme get textTheme => themeData.textTheme;

  InputDecorationThemeData get inputDecorationTheme =>
      themeData.inputDecorationTheme;

  // Helper function to get values based on DeviceType
  double _getValueForDeviceType(
    SizeType sizeType, {
    required Function(String deviceType) getValueFunction,
  }) {
    final DeviceType deviceType = DeviceType.getDeviceType(this);
    return switch (deviceType) {
      DeviceType.mobile => getValueFunction('mobile'),
      DeviceType.tablet => getValueFunction('tablet'),
      DeviceType.desktop => getValueFunction('desktop'),
    };
  }

  // Spacing
  double spacing(SizeType sizeType) {
    return _getValueForDeviceType(
      sizeType,
      getValueFunction: (deviceType) =>
          Spacings.getSpacing(sizeType, deviceType),
    );
  }

  // Font Size
  double fontSize(SizeType sizeType) {
    return _getValueForDeviceType(
      sizeType,
      getValueFunction: (deviceType) =>
          FontSizes.getFontSizes(sizeType, deviceType),
    );
  }

  // Button Size
  double buttonSize(SizeType sizeType) {
    return _getValueForDeviceType(
      sizeType,
      getValueFunction: (deviceType) =>
          ButtonSizes.getButtonSizes(sizeType, deviceType),
    );
  }

  // Margin
  double margin(SizeType sizeType) {
    return _getValueForDeviceType(
      sizeType,
      getValueFunction: (deviceType) => Margins.getMargin(sizeType, deviceType),
    );
  }
}
