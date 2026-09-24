import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';

import '../../../../datasource.mocks.dart';

// Test data
const _kCity = 'London';
const _kLang = 'en';
const _kCacheKey = 'city_london_en';

final _tCurrentWeatherModel = CurrentWeatherModel(
  name: _kCity,
  weather: const [],
  main: const CurrentMainModel(
    temp: 20.0,
    feelsLike: 21.0,
    tempMin: 18.0,
    tempMax: 22.0,
    pressure: 1012,
    humidity: 50,
  ),
  wind: const WindModel(speed: 5.0, deg: 180),
  sys: const SysModel(country: 'GB', sunrise: 1672556400, sunset: 1672596000),
  dt: 1672570000,
  timezone: 0,
  id: 2643743,
);

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDatasource mockRemote;
  late MockWeatherLocalDatasource mockLocal;

  setUp(() {
    mockRemote = MockWeatherRemoteDatasource();
    mockLocal = MockWeatherLocalDatasource();
    repository = WeatherRepositoryImpl(mockRemote, mockLocal);
  });

  group('WeatherRepositoryImpl - getCurrentWeather:', () {
    test('returns cached data when cache exists and forceRefresh is false',
        () async {
      // Arrange
      when(() => mockLocal.getCachedCurrentWeather(_kCacheKey))
          .thenAnswer((_) async => _tCurrentWeatherModel);

      // Act
      final result = await repository.getCurrentWeather(
        city: _kCity,
        lang: _kLang,
      );

      // Assert
      verify(() => mockLocal.getCachedCurrentWeather(_kCacheKey)).called(1);
      verifyNever(
        () => mockRemote.getCurrentWeather(any(), lang: any(named: 'lang')),
      );
      expect(result.cityName, _kCity);
    });

    test('fetches from remote and caches when no local data exists', () async {
      // Arrange
      when(() => mockLocal.getCachedCurrentWeather(_kCacheKey))
          .thenAnswer((_) async => null);
      when(() => mockRemote.getCurrentWeather(_kCity, lang: _kLang))
          .thenAnswer((_) async => _tCurrentWeatherModel);
      when(
        () => mockLocal.cacheCurrentWeather(_kCacheKey, _tCurrentWeatherModel),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.getCurrentWeather(
        city: _kCity,
        lang: _kLang,
      );

      // Assert
      verify(() => mockLocal.getCachedCurrentWeather(_kCacheKey)).called(1);
      verify(
        () => mockRemote.getCurrentWeather(_kCity, lang: _kLang),
      ).called(1);
      verify(
        () => mockLocal.cacheCurrentWeather(_kCacheKey, _tCurrentWeatherModel),
      ).called(1);
      expect(result.cityName, _kCity);
    });

    test('bypasses cache and fetches remote when forceRefresh is true',
        () async {
      // Arrange
      when(() => mockRemote.getCurrentWeather(_kCity, lang: _kLang))
          .thenAnswer((_) async => _tCurrentWeatherModel);
      when(
        () => mockLocal.cacheCurrentWeather(_kCacheKey, _tCurrentWeatherModel),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.getCurrentWeather(
        city: _kCity,
        lang: _kLang,
        forceRefresh: true,
      );

      // Assert
      verifyNever(() => mockLocal.getCachedCurrentWeather(any()));
      verify(
        () => mockRemote.getCurrentWeather(_kCity, lang: _kLang),
      ).called(1);
      verify(
        () => mockLocal.cacheCurrentWeather(_kCacheKey, _tCurrentWeatherModel),
      ).called(1);
      expect(result.cityName, _kCity);
    });
  });
}
