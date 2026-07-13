import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/storage/preferences_service.dart';
import 'package:weather_app/theme/providers/theme_provider.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockPreferencesService();
    // Default: always succeed when saving
    when(() => mockPrefs.saveThemeMode(any())).thenAnswer((_) async {});
  });

  ProviderContainer makeContainer({String? savedTheme}) {
    when(() => mockPrefs.getThemeMode()).thenReturn(savedTheme);
    return ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(mockPrefs),
      ],
    );
  }

  group('ThemeModeNotifier - build (initial state)', () {
    test('returns ThemeMode.system when no saved preference', () {
      final container = makeContainer(savedTheme: null);
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('returns ThemeMode.light when saved as "light"', () {
      final container = makeContainer(savedTheme: 'light');
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('returns ThemeMode.dark when saved as "dark"', () {
      final container = makeContainer(savedTheme: 'dark');
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('returns ThemeMode.system for unknown saved value', () {
      final container = makeContainer(savedTheme: 'unknown_value');
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.system);
    });
  });

  group('ThemeModeNotifier - setMode', () {
    test('setMode(dark) updates state to ThemeMode.dark', () async {
      final container = makeContainer(savedTheme: null);
      addTearDown(container.dispose);

      await container.read(themeModeProvider.notifier).setMode(ThemeMode.dark);

      expect(container.read(themeModeProvider), ThemeMode.dark);
      verify(() => mockPrefs.saveThemeMode('dark')).called(1);
    });

    test('setMode(light) updates state to ThemeMode.light', () async {
      final container = makeContainer(savedTheme: 'dark');
      addTearDown(container.dispose);

      await container.read(themeModeProvider.notifier).setMode(ThemeMode.light);

      expect(container.read(themeModeProvider), ThemeMode.light);
      verify(() => mockPrefs.saveThemeMode('light')).called(1);
    });

    test('setMode(system) saves "system" string', () async {
      final container = makeContainer(savedTheme: 'dark');
      addTearDown(container.dispose);

      await container.read(themeModeProvider.notifier).setMode(ThemeMode.system);

      verify(() => mockPrefs.saveThemeMode('system')).called(1);
    });
  });

  group('ThemeModeNotifier - cycle', () {
    test('cycle: system → light', () {
      final container = makeContainer(savedTheme: null); // system
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).cycle();

      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('cycle: light → dark', () {
      final container = makeContainer(savedTheme: 'light');
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).cycle();

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('cycle: dark → system', () {
      final container = makeContainer(savedTheme: 'dark');
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).cycle();

      expect(container.read(themeModeProvider), ThemeMode.system);
    });
  });

  group('ThemeModeNotifier - toggleLightDark', () {
    test('toggleLightDark from light → dark', () {
      final container = makeContainer(savedTheme: 'light');
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).toggleLightDark();

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('toggleLightDark from dark → light', () {
      final container = makeContainer(savedTheme: 'dark');
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).toggleLightDark();

      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('toggleLightDark from system → light (system ≠ light)', () {
      final container = makeContainer(savedTheme: null); // system ≠ light → goes to light
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).toggleLightDark();

      // state == ThemeMode.light ? dark : light  →  system != light  → light
      expect(container.read(themeModeProvider), ThemeMode.light);
    });
  });
}
