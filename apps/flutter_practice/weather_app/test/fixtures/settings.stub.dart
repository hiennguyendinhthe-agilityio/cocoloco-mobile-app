import 'package:flutter/material.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';

/// Predefined [AppSettings] stubs for use in settings-related tests.
///
/// Using stubs avoids creating the same objects repeatedly across test files.
///
/// Usage:
/// ```dart
/// when(() => mockRepository.getSettings())
///     .thenAnswer((_) async => SettingsStub.defaults);
/// ```
abstract final class SettingsStub {
  const SettingsStub._();

  /// Default settings — system theme, Celsius, Vietnamese locale.
  static const defaults = AppSettings(
    themeMode: ThemeMode.system,
    temperatureUnit: TemperatureUnit.celsius,
    locale: Locale('vi'),
  );

  /// Settings with dark theme.
  static const dark = AppSettings(
    themeMode: ThemeMode.dark,
    temperatureUnit: TemperatureUnit.celsius,
    locale: Locale('vi'),
  );

  /// Settings with light theme.
  static const light = AppSettings(
    themeMode: ThemeMode.light,
    temperatureUnit: TemperatureUnit.celsius,
    locale: Locale('vi'),
  );

  /// Settings with Fahrenheit unit.
  static const fahrenheit = AppSettings(
    themeMode: ThemeMode.system,
    temperatureUnit: TemperatureUnit.fahrenheit,
    locale: Locale('en'),
  );

  /// Settings with English locale.
  static const english = AppSettings(
    themeMode: ThemeMode.system,
    temperatureUnit: TemperatureUnit.celsius,
    locale: Locale('en'),
  );
}
