import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/localization/locale_provider.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_by_coord_usecase.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';

class MockGetForecastUseCase extends Mock implements GetForecastUseCase {}
class MockGetForecastByCoordUseCase extends Mock implements GetForecastByCoordUseCase {}

/// Stub LocaleNotifier — returns 'en' without touching SharedPreferences
class _FakeLocaleNotifier extends LocaleNotifier {
  @override
  Locale build() => const Locale('en');
}

void main() {
  late MockGetForecastUseCase mockGetForecast;
  late MockGetForecastByCoordUseCase mockGetForecastByCoord;

  final tForecast = ForecastEntity(cityName: 'London', items: []);
  final tForecastHCMC = ForecastEntity(cityName: 'Ho Chi Minh City', items: []);

  setUp(() {
    mockGetForecast = MockGetForecastUseCase();
    mockGetForecastByCoord = MockGetForecastByCoordUseCase();
  });

  ProviderContainer makeContainer() => ProviderContainer(
        overrides: [
          getForecastUseCaseProvider.overrideWithValue(mockGetForecast),
          getForecastByCoordUseCaseProvider.overrideWithValue(mockGetForecastByCoord),
          localeProvider.overrideWith(() => _FakeLocaleNotifier()),
        ],
      );

  group('ForecastNotifier - initial state', () {
    test('initial state is null', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = container.read(forecastProvider);
      expect(state.value, isNull);
    });
  });

  group('ForecastNotifier - fetchForecast (by city)', () {
    test('emits data on success', () async {
      when(() => mockGetForecast.execute(city: 'London', lang: 'en'))
          .thenAnswer((_) async => tForecast);

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(forecastProvider.notifier).fetchForecast('London');

      final state = container.read(forecastProvider);
      expect(state.value?.cityName, 'London');
    });

    test('emits error on failure', () async {
      when(() => mockGetForecast.execute(city: 'InvalidCity', lang: 'en'))
          .thenThrow(Exception('City not found'));

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(forecastProvider.notifier).fetchForecast('InvalidCity');

      expect(container.read(forecastProvider).hasError, isTrue);
    });

    test('stores last searched city for refetch', () async {
      when(() => mockGetForecast.execute(city: 'London', lang: 'en'))
          .thenAnswer((_) async => tForecast);

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(forecastProvider.notifier).fetchForecast('London');
      // Calling again should still work (verifying state is properly stored)
      await container.read(forecastProvider.notifier).fetchForecast('London');

      verify(() => mockGetForecast.execute(city: 'London', lang: 'en')).called(2);
    });
  });

  group('ForecastNotifier - fetchForecastByCoord', () {
    const tLat = 10.7769;
    const tLon = 106.7009;

    test('emits data on success', () async {
      when(() => mockGetForecastByCoord.execute(lat: tLat, lon: tLon, lang: 'en'))
          .thenAnswer((_) async => tForecastHCMC);

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(forecastProvider.notifier).fetchForecastByCoord(tLat, tLon);

      expect(container.read(forecastProvider).value?.cityName, 'Ho Chi Minh City');
    });

    test('overrides cityName when cityNameOverride is provided', () async {
      when(() => mockGetForecastByCoord.execute(lat: tLat, lon: tLon, lang: 'en'))
          .thenAnswer((_) async => tForecastHCMC);

      final container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(forecastProvider.notifier)
          .fetchForecastByCoord(tLat, tLon, cityNameOverride: 'Sài Gòn');

      expect(container.read(forecastProvider).value?.cityName, 'Sài Gòn');
    });

    test('does NOT override cityName when cityNameOverride is null', () async {
      when(() => mockGetForecastByCoord.execute(lat: tLat, lon: tLon, lang: 'en'))
          .thenAnswer((_) async => tForecastHCMC);

      final container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(forecastProvider.notifier)
          .fetchForecastByCoord(tLat, tLon);

      // cityName stays as returned by the use case
      expect(container.read(forecastProvider).value?.cityName, 'Ho Chi Minh City');
    });

    test('emits error on failure', () async {
      when(() => mockGetForecastByCoord.execute(lat: tLat, lon: tLon, lang: 'en'))
          .thenThrow(Exception('Network Error'));

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(forecastProvider.notifier).fetchForecastByCoord(tLat, tLon);

      expect(container.read(forecastProvider).hasError, isTrue);
    });
  });
}
