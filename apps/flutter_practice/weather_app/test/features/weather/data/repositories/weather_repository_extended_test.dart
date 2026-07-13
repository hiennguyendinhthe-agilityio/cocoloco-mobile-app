import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/models/location_model.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';

class MockWeatherRemoteDatasource extends Mock implements WeatherRemoteDatasource {}
class MockWeatherLocalDatasource extends Mock implements WeatherLocalDatasource {}

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDatasource mockRemote;
  late MockWeatherLocalDatasource mockLocal;

  final tCurrentWeatherModel = const CurrentWeatherModel(
    name: 'London',
    weather: [],
    main: CurrentMainModel(temp: 20.0, feelsLike: 21.0, tempMin: 18.0, tempMax: 22.0, pressure: 1012, humidity: 50),
    wind: WindModel(speed: 5.0, deg: 180),
    sys: SysModel(country: 'GB', sunrise: 1672556400, sunset: 1672596000),
    dt: 1672570000,
    timezone: 0,
    id: 2643743,
  );

  final tForecastModel = ForecastModel(
    list: [],
    city: const ForecastCityModel(id: 2643743, name: 'London', country: 'GB', timezone: 0),
  );

  final tLocationModels = [
    const LocationModel(name: 'London', lat: 51.5074, lon: -0.1278, country: 'GB', state: 'England'),
  ];

  setUpAll(() {
    registerFallbackValue(tCurrentWeatherModel);
    registerFallbackValue(tForecastModel);
  });

  setUp(() {
    mockRemote = MockWeatherRemoteDatasource();
    mockLocal = MockWeatherLocalDatasource();
    repository = WeatherRepositoryImpl(mockRemote, mockLocal);
  });

  const tLat = 51.5074;
  const tLon = -0.1278;
  const tLang = 'en';
  final tCoordKey = 'coord_${tLat.toStringAsFixed(3)}_${tLon.toStringAsFixed(3)}_$tLang';

  // ─── getForecastByCoord ────────────────────────────────────────────────────

  group('getForecastByCoord', () {
    test('returns cached forecast if available', () async {
      when(() => mockLocal.getCachedForecast(tCoordKey))
          .thenAnswer((_) async => tForecastModel);

      final result = await repository.getForecastByCoord(lat: tLat, lon: tLon, lang: tLang);

      verify(() => mockLocal.getCachedForecast(tCoordKey)).called(1);
      verifyNever(() => mockRemote.getForecastByCoord(any(), any(), lang: any(named: 'lang')));
      expect(result.cityName, 'London');
    });

    test('fetches from remote and caches when no local data', () async {
      when(() => mockLocal.getCachedForecast(tCoordKey)).thenAnswer((_) async => null);
      when(() => mockRemote.getForecastByCoord(tLat, tLon, lang: tLang))
          .thenAnswer((_) async => tForecastModel);
      when(() => mockLocal.cacheForecast(any(), any())).thenAnswer((_) async {});

      final result = await repository.getForecastByCoord(lat: tLat, lon: tLon, lang: tLang);

      verify(() => mockRemote.getForecastByCoord(tLat, tLon, lang: tLang)).called(1);
      verify(() => mockLocal.cacheForecast(tCoordKey, any())).called(1);
      expect(result.cityName, 'London');
    });

    test('falls back to expired cache when remote throws', () async {
      when(() => mockLocal.getCachedForecast(tCoordKey)).thenAnswer((_) async => null);
      when(() => mockRemote.getForecastByCoord(tLat, tLon, lang: tLang))
          .thenThrow(Exception('Network error'));
      when(() => mockLocal.getCachedForecast(tCoordKey, ignoreExpiration: true))
          .thenAnswer((_) async => tForecastModel);

      final result = await repository.getForecastByCoord(lat: tLat, lon: tLon, lang: tLang);

      expect(result.cityName, 'London');
    });

    test('rethrows when remote fails and no fallback cache', () async {
      when(() => mockLocal.getCachedForecast(tCoordKey)).thenAnswer((_) async => null);
      when(() => mockRemote.getForecastByCoord(tLat, tLon, lang: tLang))
          .thenThrow(Exception('Network error'));
      when(() => mockLocal.getCachedForecast(tCoordKey, ignoreExpiration: true))
          .thenAnswer((_) async => null);

      expect(
        () => repository.getForecastByCoord(lat: tLat, lon: tLon, lang: tLang),
        throwsA(isA<Exception>()),
      );
    });

    test('bypasses cache when forceRefresh is true', () async {
      when(() => mockRemote.getForecastByCoord(tLat, tLon, lang: tLang))
          .thenAnswer((_) async => tForecastModel);
      when(() => mockLocal.cacheForecast(any(), any())).thenAnswer((_) async {});

      await repository.getForecastByCoord(lat: tLat, lon: tLon, lang: tLang, forceRefresh: true);

      verifyNever(() => mockLocal.getCachedForecast(any()));
      verify(() => mockRemote.getForecastByCoord(tLat, tLon, lang: tLang)).called(1);
    });
  });

  // ─── searchLocation ────────────────────────────────────────────────────────

  group('searchLocation', () {
    test('returns mapped LocationEntity list from remote', () async {
      when(() => mockRemote.searchLocation('London'))
          .thenAnswer((_) async => tLocationModels);

      final result = await repository.searchLocation('London');

      expect(result.length, 1);
      expect(result.first.name, 'London');
      expect(result.first.lat, 51.5074);
      verify(() => mockRemote.searchLocation('London')).called(1);
    });

    test('returns empty list when remote returns empty', () async {
      when(() => mockRemote.searchLocation('xyz'))
          .thenAnswer((_) async => []);

      final result = await repository.searchLocation('xyz');

      expect(result, isEmpty);
    });

    test('rethrows exception when remote throws', () async {
      when(() => mockRemote.searchLocation('error'))
          .thenThrow(Exception('Search failed'));

      expect(
        () => repository.searchLocation('error'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
