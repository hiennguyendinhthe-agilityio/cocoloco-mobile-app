import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/env/app_env.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource_impl.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/models/location_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../service.mocks.dart';

const _tCurrentWeather = CurrentWeatherModel(
  name: 'London',
  dt: 123456789,
  timezone: 0,
  id: 1,
  weather: [],
  main: CurrentMainModel(
    temp: 20,
    feelsLike: 20,
    tempMin: 20,
    tempMax: 20,
    pressure: 1000,
    humidity: 50,
  ),
  wind: WindModel(speed: 1, deg: 1),
  sys: SysModel(country: 'GB', sunrise: 1, sunset: 2),
);

const _tForecast = ForecastModel(
  list: [],
  city: ForecastCityModel(id: 1, name: 'London', country: 'GB', timezone: 0),
);

final _tLocationList = [
  const LocationModel(name: 'London', lat: 51.5, lon: -0.1, country: 'GB'),
];

void main() {
  late WeatherRemoteDatasourceImpl datasource;
  late MockWeatherApi mockWeatherApi;
  late MockGeocodingApi mockGeocodingApi;

  setUpAll(() {
    dotenv.loadFromString(envString: 'OWM_API_KEY=test_key');
  });

  setUp(() {
    mockWeatherApi = MockWeatherApi();
    mockGeocodingApi = MockGeocodingApi();
    datasource = WeatherRemoteDatasourceImpl(mockWeatherApi, mockGeocodingApi);
  });

  group('WeatherRemoteDatasourceImpl - getCurrentWeather:', () {
    test('calls weatherApi.getCurrentWeatherByCity with correct params',
        () async {
      when(
        () => mockWeatherApi.getCurrentWeatherByCity(
          city: 'London',
          apiKey: AppEnv.owmApiKey,
          units: AppEnv.defaultUnits,
          lang: 'en',
        ),
      ).thenAnswer((_) async => _tCurrentWeather);

      final result = await datasource.getCurrentWeather('London', lang: 'en');

      expect(result, _tCurrentWeather);
      verify(
        () => mockWeatherApi.getCurrentWeatherByCity(
          city: 'London',
          apiKey: AppEnv.owmApiKey,
          units: AppEnv.defaultUnits,
          lang: 'en',
        ),
      ).called(1);
    });
  });

  group('WeatherRemoteDatasourceImpl - getCurrentWeatherByCoord:', () {
    test('calls weatherApi.getCurrentWeatherByCoord with correct params',
        () async {
      when(
        () => mockWeatherApi.getCurrentWeatherByCoord(
          lat: 1.0,
          lon: 2.0,
          apiKey: AppEnv.owmApiKey,
          units: AppEnv.defaultUnits,
          lang: 'vi',
        ),
      ).thenAnswer((_) async => _tCurrentWeather);

      final result =
          await datasource.getCurrentWeatherByCoord(1.0, 2.0, lang: 'vi');

      expect(result, _tCurrentWeather);
      verify(
        () => mockWeatherApi.getCurrentWeatherByCoord(
          lat: 1.0,
          lon: 2.0,
          apiKey: AppEnv.owmApiKey,
          units: AppEnv.defaultUnits,
          lang: 'vi',
        ),
      ).called(1);
    });
  });

  group('WeatherRemoteDatasourceImpl - getForecast:', () {
    test('calls weatherApi.getForecastByCity with correct params', () async {
      when(
        () => mockWeatherApi.getForecastByCity(
          city: 'London',
          apiKey: AppEnv.owmApiKey,
          units: AppEnv.defaultUnits,
          lang: 'en',
        ),
      ).thenAnswer((_) async => _tForecast);

      final result = await datasource.getForecast('London', lang: 'en');

      expect(result, _tForecast);
    });
  });

  group('WeatherRemoteDatasourceImpl - getForecastByCoord:', () {
    test('calls weatherApi.getForecastByCoord with correct params', () async {
      when(
        () => mockWeatherApi.getForecastByCoord(
          lat: 1.0,
          lon: 2.0,
          apiKey: AppEnv.owmApiKey,
          units: AppEnv.defaultUnits,
          lang: 'en',
        ),
      ).thenAnswer((_) async => _tForecast);

      final result =
          await datasource.getForecastByCoord(1.0, 2.0, lang: 'en');

      expect(result, _tForecast);
    });
  });

  group('WeatherRemoteDatasourceImpl - searchLocation:', () {
    test('calls geocodingApi.searchLocation with correct params', () async {
      when(
        () => mockGeocodingApi.searchLocation(
          query: 'London',
          apiKey: AppEnv.owmApiKey,
        ),
      ).thenAnswer((_) async => _tLocationList);

      final result = await datasource.searchLocation('London');

      expect(result, _tLocationList);
      verify(
        () => mockGeocodingApi.searchLocation(
          query: 'London',
          apiKey: AppEnv.owmApiKey,
        ),
      ).called(1);
    });
  });
}
