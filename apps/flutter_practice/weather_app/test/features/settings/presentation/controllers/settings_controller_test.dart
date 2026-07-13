import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/settings/domain/entities/app_settings.dart';
import 'package:weather_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:weather_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weather_app/features/settings/presentation/controllers/settings_controller.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late ProviderContainer container;
  late MockSettingsRepository mockRepository;

  const tDefaultSettings = AppSettings(
    themeMode: ThemeMode.system,
    temperatureUnit: TemperatureUnit.celsius,
    locale: Locale('vi'),
  );

  setUpAll(() {
    registerFallbackValue(tDefaultSettings);
  });

  setUp(() {
    mockRepository = MockSettingsRepository();
    when(() => mockRepository.getSettings()).thenAnswer((_) async => tDefaultSettings);
    when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        // Override the Repository provider directly
        settingsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('initial build loads settings from repository', () async {
    final result = await container.read(settingsControllerProvider.future);

    expect(result.themeMode, ThemeMode.system);
    expect(result.temperatureUnit, TemperatureUnit.celsius);
    verify(() => mockRepository.getSettings()).called(1);
  });

  test('updateThemeMode updates state optimistically and saves', () async {
    // Wait for initial load
    await container.read(settingsControllerProvider.future);

    await container.read(settingsControllerProvider.notifier).updateThemeMode(ThemeMode.dark);

    final updated = container.read(settingsControllerProvider).value;
    expect(updated?.themeMode, ThemeMode.dark);
    // Only the locale stays the same
    expect(updated?.temperatureUnit, TemperatureUnit.celsius);
    verify(() => mockRepository.saveSettings(any())).called(1);
  });

  test('updateTemperatureUnit updates state and saves', () async {
    await container.read(settingsControllerProvider.future);

    await container
        .read(settingsControllerProvider.notifier)
        .updateTemperatureUnit(TemperatureUnit.fahrenheit);

    final updated = container.read(settingsControllerProvider).value;
    expect(updated?.temperatureUnit, TemperatureUnit.fahrenheit);
    verify(() => mockRepository.saveSettings(any())).called(1);
  });

  test('updateLocale updates state and saves', () async {
    await container.read(settingsControllerProvider.future);

    await container
        .read(settingsControllerProvider.notifier)
        .updateLocale(const Locale('en'));

    final updated = container.read(settingsControllerProvider).value;
    expect(updated?.locale, const Locale('en'));
    verify(() => mockRepository.saveSettings(any())).called(1);
  });

  test('sets AsyncError state when save throws', () async {
    when(() => mockRepository.saveSettings(any())).thenThrow(Exception('Save failed'));
    await container.read(settingsControllerProvider.future);

    await container.read(settingsControllerProvider.notifier).updateThemeMode(ThemeMode.light);

    expect(container.read(settingsControllerProvider).hasError, isTrue);
  });
}
