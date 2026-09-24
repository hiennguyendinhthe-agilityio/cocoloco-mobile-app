import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';
import 'package:weather_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weather_app/features/settings/presentation/controllers/settings_controller.dart';

import '../../../../repository.mocks.dart';
import '../../../../fixtures/settings.stub.dart';
import '../../../../test_utils.dart';

void main() {
  late MockSettingsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(SettingsStub.defaults);
  });

  setUp(() {
    mockRepository = MockSettingsRepository();
    when(() => mockRepository.getSettings())
        .thenAnswer((_) async => SettingsStub.defaults);
    when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
  });

  ProviderContainer makeContainer() => TestUtils.createContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

  group('SettingsController - initial build:', () {
    test('loads settings from repository', () async {
      final container = makeContainer();
      final result = await container.read(settingsControllerProvider.future);

      expect(result.themeMode, ThemeMode.system);
      expect(result.temperatureUnit, TemperatureUnit.celsius);
      verify(() => mockRepository.getSettings()).called(1);
    });
  });

  group('SettingsController - updateThemeMode:', () {
    test('updates state optimistically and saves', () async {
      final container = makeContainer();
      await container.read(settingsControllerProvider.future);

      await container
          .read(settingsControllerProvider.notifier)
          .updateThemeMode(ThemeMode.dark);

      final updated = container.read(settingsControllerProvider).value;
      expect(updated?.themeMode, ThemeMode.dark);
      expect(updated?.temperatureUnit, TemperatureUnit.celsius);
      verify(() => mockRepository.saveSettings(any())).called(1);
    });

    test('sets AsyncError state when save throws', () async {
      when(() => mockRepository.saveSettings(any()))
          .thenThrow(Exception('Save failed'));
      final container = makeContainer();
      await container.read(settingsControllerProvider.future);

      await container
          .read(settingsControllerProvider.notifier)
          .updateThemeMode(ThemeMode.light);

      expect(container.read(settingsControllerProvider).hasError, isTrue);
    });
  });

  group('SettingsController - updateTemperatureUnit:', () {
    test('updates state and saves to repository', () async {
      final container = makeContainer();
      await container.read(settingsControllerProvider.future);

      await container
          .read(settingsControllerProvider.notifier)
          .updateTemperatureUnit(TemperatureUnit.fahrenheit);

      final updated = container.read(settingsControllerProvider).value;
      expect(updated?.temperatureUnit, TemperatureUnit.fahrenheit);
      verify(() => mockRepository.saveSettings(any())).called(1);
    });
  });

  group('SettingsController - updateLocale:', () {
    test('updates state and saves to repository', () async {
      final container = makeContainer();
      await container.read(settingsControllerProvider.future);

      await container
          .read(settingsControllerProvider.notifier)
          .updateLocale(const Locale('en'));

      final updated = container.read(settingsControllerProvider).value;
      expect(updated?.locale, const Locale('en'));
      verify(() => mockRepository.saveSettings(any())).called(1);
    });
  });
}
