import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';

class MockWeatherRemoteDatasource extends Mock implements WeatherRemoteDatasource {}
class MockWeatherLocalDatasource extends Mock implements WeatherLocalDatasource {}

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDatasource mockRemote;
  late MockWeatherLocalDatasource mockLocal;

  // Register fallback values for argument matchers
  setUpAll(() {
    registerFallbackValue(const CurrentWeatherModel(
      name: '',
      weather: [],
      main: CurrentMainModel(temp: 0, feelsLike: 0, tempMin: 0, tempMax: 0, pressure: 0, humidity: 0),
      wind: WindModel(speed: 0, deg: 0),
      sys: SysModel(country: 'US', sunrise: 0, sunset: 0),
      dt: 0,
      timezone: 0,
      id: 0,
    ));
    registerFallbackValue(ForecastModel(
      list: [],
      city: const ForecastCityModel(id: 0, name: '', country: '', timezone: 0),
    ));
  });

  setUp(() {
    mockRemote = MockWeatherRemoteDatasource();
    mockLocal = MockWeatherLocalDatasource();
    repository = WeatherRepositoryImpl(mockRemote, mockLocal);
  });

  const tLat = 51.5074;
  const tLon = -0.1278;
  const tLang = 'en';
  // key uses toStringAsFixed(3)
  final tCoordCacheKey = 'coord_${tLat.toStringAsFixed(3)}_${tLon.toStringAsFixed(3)}_$tLang';

  final tCurrentWeatherModel = CurrentWeatherModel(
    name: 'London',
    weather: [],
    main: const CurrentMainModel(temp: 20.0, feelsLike: 21.0, tempMin: 18.0, tempMax: 22.0, pressure: 1012, humidity: 50),
    wind: const WindModel(speed: 5.0, deg: 180),
    sys: const SysModel(country: 'GB', sunrise: 1672556400, sunset: 1672596000),
    dt: 1672570000,
    timezone: 0,
    id: 2643743,
  );

  final tForecastModel = ForecastModel(
    list: [],
    city: const ForecastCityModel(id: 2643743, name: 'London', country: 'GB', timezone: 0),
  );

  group('getCurrentWeatherByCoord', () {
    test('should return cached data if available', () async {
      when(() => mockLocal.getCachedCurrentWeather(tCoordCacheKey))
          .thenAnswer((_) async => tCurrentWeatherModel);

      final result = await repository.getCurrentWeatherByCoord(lat: tLat, lon: tLon, lang: tLang);

      verify(() => mockLocal.getCachedCurrentWeather(tCoordCacheKey)).called(1);
      verifyNever(() => mockRemote.getCurrentWeatherByCoord(any(), any(), lang: any(named: 'lang')));
      expect(result.cityName, 'London');
    });

    test('should fetch from remote and cache when no local data', () async {
      when(() => mockLocal.getCachedCurrentWeather(tCoordCacheKey))
          .thenAnswer((_) async => null);
      when(() => mockRemote.getCurrentWeatherByCoord(tLat, tLon, lang: tLang))
          .thenAnswer((_) async => tCurrentWeatherModel);
      when(() => mockLocal.cacheCurrentWeather(any(), any()))
          .thenAnswer((_) async {});

      final result = await repository.getCurrentWeatherByCoord(lat: tLat, lon: tLon, lang: tLang);

      verify(() => mockRemote.getCurrentWeatherByCoord(tLat, tLon, lang: tLang)).called(1);
      verify(() => mockLocal.cacheCurrentWeather(tCoordCacheKey, any())).called(1);
      expect(result.cityName, 'London');
    });

    test('should fall back to expired cache when remote throws', () async {
      when(() => mockLocal.getCachedCurrentWeather(tCoordCacheKey))
          .thenAnswer((_) async => null);
      when(() => mockRemote.getCurrentWeatherByCoord(tLat, tLon, lang: tLang))
          .thenThrow(Exception('Network Error'));
      when(() => mockLocal.getCachedCurrentWeather(tCoordCacheKey, ignoreExpiration: true))
          .thenAnswer((_) async => tCurrentWeatherModel);

      final result = await repository.getCurrentWeatherByCoord(lat: tLat, lon: tLon, lang: tLang);

      expect(result.cityName, 'London');
    });

    test('should rethrow when remote throws and no fallback cache', () async {
      when(() => mockLocal.getCachedCurrentWeather(tCoordCacheKey))
          .thenAnswer((_) async => null);
      when(() => mockRemote.getCurrentWeatherByCoord(tLat, tLon, lang: tLang))
          .thenThrow(Exception('Network Error'));
      when(() => mockLocal.getCachedCurrentWeather(tCoordCacheKey, ignoreExpiration: true))
          .thenAnswer((_) async => null);

      expect(
        () => repository.getCurrentWeatherByCoord(lat: tLat, lon: tLon, lang: tLang),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getForecast (city)', () {
    const tCity = 'London';
    final tForecastCacheKey = 'city_${tCity.toLowerCase()}_$tLang';

    test('should return cached forecast if available', () async {
      when(() => mockLocal.getCachedForecast(tForecastCacheKey))
          .thenAnswer((_) async => tForecastModel);

      final result = await repository.getForecast(city: tCity, lang: tLang);

      verify(() => mockLocal.getCachedForecast(tForecastCacheKey)).called(1);
      verifyNever(() => mockRemote.getForecast(any(), lang: any(named: 'lang')));
      expect(result.cityName, 'London');
    });

    test('should fetch from remote and cache when no local forecast', () async {
      when(() => mockLocal.getCachedForecast(tForecastCacheKey))
          .thenAnswer((_) async => null);
      when(() => mockRemote.getForecast(tCity, lang: tLang))
          .thenAnswer((_) async => tForecastModel);
      when(() => mockLocal.cacheForecast(any(), any()))
          .thenAnswer((_) async {});

      final result = await repository.getForecast(city: tCity, lang: tLang);

      verify(() => mockRemote.getForecast(tCity, lang: tLang)).called(1);
      expect(result.cityName, 'London');
    });

    test('should fall back to expired cache when remote throws', () async {
      when(() => mockLocal.getCachedForecast(tForecastCacheKey))
          .thenAnswer((_) async => null);
      when(() => mockRemote.getForecast(tCity, lang: tLang))
          .thenThrow(Exception('No internet'));
      when(() => mockLocal.getCachedForecast(tForecastCacheKey, ignoreExpiration: true))
          .thenAnswer((_) async => tForecastModel);

      final result = await repository.getForecast(city: tCity, lang: tLang);

      expect(result.cityName, 'London');
    });
  });
}
