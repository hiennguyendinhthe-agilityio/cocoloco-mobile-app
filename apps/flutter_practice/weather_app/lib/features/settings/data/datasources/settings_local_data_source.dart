import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/storage/preferences_service.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';

final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl(ref.watch(sharedPreferencesProvider));
});

abstract class SettingsLocalDataSource {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;

  static const _themeKey = 'settings_theme_mode';
  static const _unitKey = 'settings_temperature_unit';
  static const _localeKey = 'settings_locale';

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<AppSettings> getSettings() async {
    final themeStr = _prefs.getString(_themeKey);
    final unitStr = _prefs.getString(_unitKey);
    final localeStr = _prefs.getString(_localeKey);

    ThemeMode themeMode = ThemeMode.system;
    if (themeStr == 'light') themeMode = ThemeMode.light;
    if (themeStr == 'dark') themeMode = ThemeMode.dark;

    TemperatureUnit unit = TemperatureUnit.celsius;
    if (unitStr == 'fahrenheit') unit = TemperatureUnit.fahrenheit;

    Locale locale = const Locale('vi');
    if (localeStr != null && localeStr.isNotEmpty) {
      locale = Locale(localeStr);
    }

    return AppSettings(
      themeMode: themeMode,
      temperatureUnit: unit,
      locale: locale,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    String themeStr = 'system';
    if (settings.themeMode == ThemeMode.light) themeStr = 'light';
    if (settings.themeMode == ThemeMode.dark) themeStr = 'dark';

    String unitStr = 'celsius';
    if (settings.temperatureUnit == TemperatureUnit.fahrenheit) unitStr = 'fahrenheit';

    await Future.wait([
      _prefs.setString(_themeKey, themeStr),
      _prefs.setString(_unitKey, unitStr),
      _prefs.setString(_localeKey, settings.locale.languageCode),
    ]);
  }
}
