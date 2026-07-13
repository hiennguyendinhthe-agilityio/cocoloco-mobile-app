import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SettingsLocalDataSourceImpl datasource;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    datasource = SettingsLocalDataSourceImpl(mockPrefs);
  });

  group('SettingsLocalDataSourceImpl - getSettings', () {
    test('should return system theme / celsius / vi when no saved data', () async {
      when(() => mockPrefs.getString('settings_theme_mode')).thenReturn(null);
      when(() => mockPrefs.getString('settings_temperature_unit')).thenReturn(null);
      when(() => mockPrefs.getString('settings_locale')).thenReturn(null);

      final result = await datasource.getSettings();

      expect(result.themeMode, ThemeMode.system);
      expect(result.temperatureUnit, TemperatureUnit.celsius);
      expect(result.locale, const Locale('vi'));
    });

    test('should return light theme when stored "light"', () async {
      when(() => mockPrefs.getString('settings_theme_mode')).thenReturn('light');
      when(() => mockPrefs.getString('settings_temperature_unit')).thenReturn(null);
      when(() => mockPrefs.getString('settings_locale')).thenReturn(null);

      final result = await datasource.getSettings();

      expect(result.themeMode, ThemeMode.light);
    });

    test('should return dark theme when stored "dark"', () async {
      when(() => mockPrefs.getString('settings_theme_mode')).thenReturn('dark');
      when(() => mockPrefs.getString('settings_temperature_unit')).thenReturn(null);
      when(() => mockPrefs.getString('settings_locale')).thenReturn(null);

      final result = await datasource.getSettings();

      expect(result.themeMode, ThemeMode.dark);
    });

    test('should return fahrenheit when stored "fahrenheit"', () async {
      when(() => mockPrefs.getString('settings_theme_mode')).thenReturn(null);
      when(() => mockPrefs.getString('settings_temperature_unit')).thenReturn('fahrenheit');
      when(() => mockPrefs.getString('settings_locale')).thenReturn(null);

      final result = await datasource.getSettings();

      expect(result.temperatureUnit, TemperatureUnit.fahrenheit);
    });

    test('should return correct locale when stored "en"', () async {
      when(() => mockPrefs.getString('settings_theme_mode')).thenReturn(null);
      when(() => mockPrefs.getString('settings_temperature_unit')).thenReturn(null);
      when(() => mockPrefs.getString('settings_locale')).thenReturn('en');

      final result = await datasource.getSettings();

      expect(result.locale, const Locale('en'));
    });
  });

  group('SettingsLocalDataSourceImpl - saveSettings', () {
    test('should save system theme as "system"', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      const settings = AppSettings(
        themeMode: ThemeMode.system,
        temperatureUnit: TemperatureUnit.celsius,
        locale: Locale('vi'),
      );

      await datasource.saveSettings(settings);

      verify(() => mockPrefs.setString('settings_theme_mode', 'system')).called(1);
      verify(() => mockPrefs.setString('settings_temperature_unit', 'celsius')).called(1);
      verify(() => mockPrefs.setString('settings_locale', 'vi')).called(1);
    });

    test('should save dark theme as "dark"', () async {
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      const settings = AppSettings(
        themeMode: ThemeMode.dark,
        temperatureUnit: TemperatureUnit.fahrenheit,
        locale: Locale('en'),
      );

      await datasource.saveSettings(settings);

      verify(() => mockPrefs.setString('settings_theme_mode', 'dark')).called(1);
      verify(() => mockPrefs.setString('settings_temperature_unit', 'fahrenheit')).called(1);
      verify(() => mockPrefs.setString('settings_locale', 'en')).called(1);
    });
  });
}
