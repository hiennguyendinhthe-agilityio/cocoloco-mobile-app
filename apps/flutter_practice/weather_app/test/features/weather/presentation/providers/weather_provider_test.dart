import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/localization/locale_provider.dart';
import 'package:weather_app/core/storage/preferences_service.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/di_providers.dart';

import '../../../../service.mocks.dart';
import '../../../../repository.mocks.dart';
import '../../../../test_utils.dart';
import '../../../../fixtures/weather.stub.dart';

void main() {
  late MockGetCurrentWeatherUseCase mockUseCase;
  late MockGetCurrentWeatherByCoordUseCase mockByCoordUseCase;
  late MockPreferencesService mockPrefs;

  setUp(() {
    mockUseCase = MockGetCurrentWeatherUseCase();
    mockByCoordUseCase = MockGetCurrentWeatherByCoordUseCase();
    mockPrefs = MockPreferencesService();

    when(() => mockPrefs.saveLanguageCode(any())).thenAnswer((_) async => true);
    when(() => mockPrefs.getLanguageCode()).thenReturn('en');
  });

  ProviderContainer makeContainer() => TestUtils.createContainer(
        overrides: [
          getCurrentWeatherUseCaseProvider.overrideWithValue(mockUseCase),
          getCurrentWeatherByCoordUseCaseProvider
              .overrideWithValue(mockByCoordUseCase),
          preferencesServiceProvider.overrideWithValue(mockPrefs),
        ],
      );

  group('WeatherNotifier - initial state:', () {
    test('value is null before any fetch', () {
      final container = makeContainer();
      expect(container.read(weatherProvider).value, isNull);
    });
  });

  group('WeatherNotifier - fetchWeather:', () {
    test('emits loading then data on success', () async {
      // Arrange
      final container = makeContainer();
      when(() => mockUseCase.execute(city: 'London', lang: 'en'))
          .thenAnswer((_) async => WeatherStub.london);

      // Act
      final fetchFuture =
          container.read(weatherProvider.notifier).fetchWeather('London');

      // Verify loading state is set immediately
      expect(container.read(weatherProvider).isLoading, true);
      await fetchFuture;

      // Assert data state
      expect(container.read(weatherProvider).value, WeatherStub.london);
      verify(() => mockUseCase.execute(city: 'London', lang: 'en')).called(1);
    });

    test('emits error state on failure', () async {
      // Arrange
      final container = makeContainer();
      final exception = Exception('Network error');
      when(() => mockUseCase.execute(city: 'London', lang: 'en'))
          .thenThrow(exception);

      // Act
      await container.read(weatherProvider.notifier).fetchWeather('London');

      // Assert
      final state = container.read(weatherProvider);
      expect(state.hasError, true);
      expect(state.error, exception);
    });

    test('re-fetches with new lang when localeProvider changes', () async {
      // Arrange
      final container = makeContainer();
      when(() => mockUseCase.execute(city: 'London', lang: 'en'))
          .thenAnswer((_) async => WeatherStub.london);
      await container.read(weatherProvider.notifier).fetchWeather('London');
      expect(container.read(weatherProvider).value?.cityName, 'London');

      // Prepare localized response
      final tWeatherVi = WeatherStub.london.copyWith(condition: 'Mây đen u ám');
      when(() => mockUseCase.execute(city: 'London', lang: 'vi'))
          .thenAnswer((_) async => tWeatherVi);

      // Act: change locale
      await container
          .read(localeProvider.notifier)
          .setLocale(const Locale('vi'));
      await Future.delayed(Duration.zero);

      // Assert: re-fetched with Vietnamese
      verify(() => mockUseCase.execute(city: 'London', lang: 'vi')).called(1);
      expect(
        container.read(weatherProvider).value?.condition,
        'Mây đen u ám',
      );
    });
  });

  group('WeatherNotifier - fetchWeatherByCoord:', () {
    const tLat = 10.7769;
    const tLon = 106.7009;

    test('emits data on success', () async {
      final container = makeContainer();
      when(
        () => mockByCoordUseCase.execute(lat: tLat, lon: tLon, lang: 'en'),
      ).thenAnswer((_) async => WeatherStub.london);

      await container
          .read(weatherProvider.notifier)
          .fetchWeatherByCoord(tLat, tLon);

      expect(container.read(weatherProvider).value?.cityName, 'London');
    });

    test('overrides cityName when cityNameOverride is non-empty', () async {
      final container = makeContainer();
      when(
        () => mockByCoordUseCase.execute(lat: tLat, lon: tLon, lang: 'en'),
      ).thenAnswer((_) async => WeatherStub.london);

      await container
          .read(weatherProvider.notifier)
          .fetchWeatherByCoord(tLat, tLon, cityNameOverride: 'Sài Gòn');

      expect(container.read(weatherProvider).value?.cityName, 'Sài Gòn');
    });

    test('does NOT override cityName when cityNameOverride is empty', () async {
      final container = makeContainer();
      when(
        () => mockByCoordUseCase.execute(lat: tLat, lon: tLon, lang: 'en'),
      ).thenAnswer((_) async => WeatherStub.london);

      await container
          .read(weatherProvider.notifier)
          .fetchWeatherByCoord(tLat, tLon, cityNameOverride: '');

      expect(container.read(weatherProvider).value?.cityName, 'London');
    });

    test('emits error on failure', () async {
      final container = makeContainer();
      when(
        () => mockByCoordUseCase.execute(lat: tLat, lon: tLon, lang: 'en'),
      ).thenThrow(Exception('No internet'));

      await container
          .read(weatherProvider.notifier)
          .fetchWeatherByCoord(tLat, tLon);

      expect(container.read(weatherProvider).hasError, isTrue);
    });
  });
}
