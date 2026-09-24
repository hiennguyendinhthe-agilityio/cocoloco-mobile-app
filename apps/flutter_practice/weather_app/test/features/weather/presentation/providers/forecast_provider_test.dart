import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/localization/locale_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/di_providers.dart';

import '../../../../service.mocks.dart';
import '../../../../test_utils.dart';
import '../../../../fixtures/forecast.stub.dart';

/// Stub LocaleNotifier that returns 'en' without touching SharedPreferences.
class _FakeLocaleNotifier extends LocaleNotifier {
  @override
  Locale build() => const Locale('en');
}

void main() {
  late MockGetForecastUseCase mockGetForecast;
  late MockGetForecastByCoordUseCase mockGetForecastByCoord;

  setUp(() {
    mockGetForecast = MockGetForecastUseCase();
    mockGetForecastByCoord = MockGetForecastByCoordUseCase();
  });

  ProviderContainer makeContainer() => TestUtils.createContainer(
        overrides: [
          getForecastUseCaseProvider.overrideWithValue(mockGetForecast),
          getForecastByCoordUseCaseProvider
              .overrideWithValue(mockGetForecastByCoord),
          localeProvider.overrideWith(() => _FakeLocaleNotifier()),
        ],
      );

  group('ForecastNotifier - initial state:', () {
    test('value is null before any fetch', () {
      final container = makeContainer();
      expect(container.read(forecastProvider).value, isNull);
    });
  });

  group('ForecastNotifier - fetchForecast (by city):', () {
    test('emits data on success', () async {
      when(() => mockGetForecast.execute(city: 'London', lang: 'en'))
          .thenAnswer((_) async => ForecastStub.london);

      final container = makeContainer();
      await container.read(forecastProvider.notifier).fetchForecast('London');

      expect(container.read(forecastProvider).value?.cityName, 'London');
    });

    test('emits error on failure', () async {
      when(() => mockGetForecast.execute(city: 'InvalidCity', lang: 'en'))
          .thenThrow(Exception('City not found'));

      final container = makeContainer();
      await container
          .read(forecastProvider.notifier)
          .fetchForecast('InvalidCity');

      expect(container.read(forecastProvider).hasError, isTrue);
    });

    test('can be fetched multiple times (state is properly maintained)',
        () async {
      when(() => mockGetForecast.execute(city: 'London', lang: 'en'))
          .thenAnswer((_) async => ForecastStub.london);

      final container = makeContainer();
      await container.read(forecastProvider.notifier).fetchForecast('London');
      await container.read(forecastProvider.notifier).fetchForecast('London');

      verify(() => mockGetForecast.execute(city: 'London', lang: 'en'))
          .called(2);
    });
  });

  group('ForecastNotifier - fetchForecastByCoord:', () {
    const tLat = 10.7769;
    const tLon = 106.7009;

    test('emits data on success', () async {
      when(
        () =>
            mockGetForecastByCoord.execute(lat: tLat, lon: tLon, lang: 'en'),
      ).thenAnswer((_) async => ForecastStub.hoChiMinh);

      final container = makeContainer();
      await container
          .read(forecastProvider.notifier)
          .fetchForecastByCoord(tLat, tLon);

      expect(
        container.read(forecastProvider).value?.cityName,
        'Ho Chi Minh City',
      );
    });

    test('overrides cityName when cityNameOverride is provided', () async {
      when(
        () =>
            mockGetForecastByCoord.execute(lat: tLat, lon: tLon, lang: 'en'),
      ).thenAnswer((_) async => ForecastStub.hoChiMinh);

      final container = makeContainer();
      await container
          .read(forecastProvider.notifier)
          .fetchForecastByCoord(tLat, tLon, cityNameOverride: 'Sài Gòn');

      expect(container.read(forecastProvider).value?.cityName, 'Sài Gòn');
    });

    test('does NOT override cityName when cityNameOverride is null', () async {
      when(
        () =>
            mockGetForecastByCoord.execute(lat: tLat, lon: tLon, lang: 'en'),
      ).thenAnswer((_) async => ForecastStub.hoChiMinh);

      final container = makeContainer();
      await container
          .read(forecastProvider.notifier)
          .fetchForecastByCoord(tLat, tLon);

      expect(
        container.read(forecastProvider).value?.cityName,
        'Ho Chi Minh City',
      );
    });

    test('emits error on failure', () async {
      when(
        () =>
            mockGetForecastByCoord.execute(lat: tLat, lon: tLon, lang: 'en'),
      ).thenThrow(Exception('Network Error'));

      final container = makeContainer();
      await container
          .read(forecastProvider.notifier)
          .fetchForecastByCoord(tLat, tLon);

      expect(container.read(forecastProvider).hasError, isTrue);
    });
  });
}
