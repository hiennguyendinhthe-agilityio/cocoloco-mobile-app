import 'package:flutter/material.dart';

enum TemperatureUnit {
  celsius,
  fahrenheit,
}

class AppSettings {
  final ThemeMode themeMode;
  final TemperatureUnit temperatureUnit;
  final Locale locale;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.locale = const Locale('vi'),
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    TemperatureUnit? temperatureUnit,
    Locale? locale,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      locale: locale ?? this.locale,
    );
  }
}
