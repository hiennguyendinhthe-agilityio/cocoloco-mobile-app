import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/storage/preferences_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late PreferencesService service;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    service = PreferencesService(mockPrefs);
  });

  group('PreferencesService - Language', () {
    test('getLanguageCode returns null when not set', () {
      when(() => mockPrefs.getString('language_code')).thenReturn(null);

      final result = service.getLanguageCode();

      expect(result, isNull);
    });

    test('getLanguageCode returns saved value', () {
      when(() => mockPrefs.getString('language_code')).thenReturn('vi');

      final result = service.getLanguageCode();

      expect(result, 'vi');
    });

    test('saveLanguageCode calls setString with correct key', () async {
      when(() => mockPrefs.setString('language_code', 'en'))
          .thenAnswer((_) async => true);

      await service.saveLanguageCode('en');

      verify(() => mockPrefs.setString('language_code', 'en')).called(1);
    });
  });

  group('PreferencesService - Theme', () {
    test('getThemeMode returns null when not set', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn(null);

      final result = service.getThemeMode();

      expect(result, isNull);
    });

    test('getThemeMode returns saved value "dark"', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn('dark');

      final result = service.getThemeMode();

      expect(result, 'dark');
    });

    test('saveThemeMode calls setString with correct key', () async {
      when(() => mockPrefs.setString('theme_mode', 'dark'))
          .thenAnswer((_) async => true);

      await service.saveThemeMode('dark');

      verify(() => mockPrefs.setString('theme_mode', 'dark')).called(1);
    });
  });
}
