import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';

class MockWeatherRemoteDatasource extends Mock implements WeatherRemoteDatasource {}
class MockWeatherLocalDatasource extends Mock implements WeatherLocalDatasource {}

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDatasource mockRemote;
  late MockWeatherLocalDatasource mockLocal;

  setUp(() {
    mockRemote = MockWeatherRemoteDatasource();
    mockLocal = MockWeatherLocalDatasource();
    repository = WeatherRepositoryImpl(mockRemote, mockLocal);
  });

  const tCity = 'London';
  const tLang = 'en';
  const tCacheKey = 'city_london_en';

  final tCurrentWeatherModel = CurrentWeatherModel(
    name: tCity,
    weather: [],
    main: const CurrentMainModel(temp: 20.0, feelsLike: 21.0, tempMin: 18.0, tempMax: 22.0, pressure: 1012, humidity: 50),
    wind: const WindModel(speed: 5.0, deg: 180),
    sys: const SysModel(country: 'GB', sunrise: 1672556400, sunset: 1672596000),
    dt: 1672570000,
    timezone: 0,
    id: 2643743,
  );

  group('getCurrentWeather', () {
    test('should return cached data if available and not force refresh', () async {
      // Arrange
      when(() => mockLocal.getCachedCurrentWeather(tCacheKey))
          .thenAnswer((_) async => tCurrentWeatherModel);

      // Act
      final result = await repository.getCurrentWeather(city: tCity, lang: tLang);

      // Assert
      verify(() => mockLocal.getCachedCurrentWeather(tCacheKey)).called(1);
      verifyNever(() => mockRemote.getCurrentWeather(any(), lang: any(named: 'lang')));
      expect(result.cityName, tCity);
    });

    test('should fetch remote and cache it if no local data exists', () async {
      // Arrange
      when(() => mockLocal.getCachedCurrentWeather(tCacheKey))
          .thenAnswer((_) async => null);
      when(() => mockRemote.getCurrentWeather(tCity, lang: tLang))
          .thenAnswer((_) async => tCurrentWeatherModel);
      when(() => mockLocal.cacheCurrentWeather(tCacheKey, tCurrentWeatherModel))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getCurrentWeather(city: tCity, lang: tLang);

      // Assert
      verify(() => mockLocal.getCachedCurrentWeather(tCacheKey)).called(1);
      verify(() => mockRemote.getCurrentWeather(tCity, lang: tLang)).called(1);
      verify(() => mockLocal.cacheCurrentWeather(tCacheKey, tCurrentWeatherModel)).called(1);
      expect(result.cityName, tCity);
    });

    test('should bypass cache and fetch remote if forceRefresh is true', () async {
      // Arrange
      when(() => mockRemote.getCurrentWeather(tCity, lang: tLang))
          .thenAnswer((_) async => tCurrentWeatherModel);
      when(() => mockLocal.cacheCurrentWeather(tCacheKey, tCurrentWeatherModel))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getCurrentWeather(city: tCity, lang: tLang, forceRefresh: true);

      // Assert
      verifyNever(() => mockLocal.getCachedCurrentWeather(any()));
      verify(() => mockRemote.getCurrentWeather(tCity, lang: tLang)).called(1);
      verify(() => mockLocal.cacheCurrentWeather(tCacheKey, tCurrentWeatherModel)).called(1);
      expect(result.cityName, tCity);
    });
  });
}
