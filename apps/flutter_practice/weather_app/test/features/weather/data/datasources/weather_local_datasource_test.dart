import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';

class MockBox extends Mock implements Box {}

void main() {
  late WeatherLocalDatasourceImpl datasource;
  late MockBox mockWeatherBox;
  late MockBox mockForecastBox;

  // A minimal valid CurrentWeatherModel JSON
  final tWeatherModel = const CurrentWeatherModel(
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
    city: const ForecastCityModel(id: 1, name: 'London', country: 'GB', timezone: 0),
  );

  setUp(() {
    mockWeatherBox = MockBox();
    mockForecastBox = MockBox();
    datasource = WeatherLocalDatasourceImpl(mockWeatherBox, mockForecastBox);
  });

  group('getCachedCurrentWeather', () {
    test('returns null when no data in box', () async {
      when(() => mockWeatherBox.get('key_1')).thenReturn(null);

      final result = await datasource.getCachedCurrentWeather('key_1');

      expect(result, isNull);
    });

    test('returns model when cache is fresh', () async {
      final freshTimestamp = DateTime.now().millisecondsSinceEpoch;
      when(() => mockWeatherBox.get('key_1')).thenReturn({
        'timestamp': freshTimestamp,
        'data': jsonEncode(tWeatherModel.toJson()),
      });

      final result = await datasource.getCachedCurrentWeather('key_1');

      expect(result, isNotNull);
      expect(result?.name, 'London');
    });

    test('returns null and deletes entry when cache is expired', () async {
      // 3 hours ago → expired
      final expiredTimestamp = DateTime.now()
          .subtract(const Duration(hours: 3))
          .millisecondsSinceEpoch;
      when(() => mockWeatherBox.get('key_1')).thenReturn({
        'timestamp': expiredTimestamp,
        'data': jsonEncode(tWeatherModel.toJson()),
      });
      when(() => mockWeatherBox.delete('key_1')).thenAnswer((_) async {});

      final result = await datasource.getCachedCurrentWeather('key_1');

      expect(result, isNull);
      verify(() => mockWeatherBox.delete('key_1')).called(1);
    });

    test('returns model even when expired if ignoreExpiration=true', () async {
      final expiredTimestamp = DateTime.now()
          .subtract(const Duration(hours: 3))
          .millisecondsSinceEpoch;
      when(() => mockWeatherBox.get('key_1')).thenReturn({
        'timestamp': expiredTimestamp,
        'data': jsonEncode(tWeatherModel.toJson()),
      });

      final result = await datasource.getCachedCurrentWeather('key_1', ignoreExpiration: true);

      expect(result, isNotNull);
      expect(result?.name, 'London');
      verifyNever(() => mockWeatherBox.delete(any()));
    });

    test('returns null when data is corrupted JSON', () async {
      when(() => mockWeatherBox.get('key_1')).thenReturn({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': 'NOT_VALID_JSON{{{',
      });

      final result = await datasource.getCachedCurrentWeather('key_1');

      expect(result, isNull);
    });
  });

  group('cacheCurrentWeather', () {
    test('stores data with current timestamp in box', () async {
      when(() => mockWeatherBox.put(any(), any())).thenAnswer((_) async {});

      await datasource.cacheCurrentWeather('key_1', tWeatherModel);

      final captured = verify(() => mockWeatherBox.put('key_1', captureAny())).captured.first
          as Map;
      expect(captured.containsKey('timestamp'), isTrue);
      expect(captured.containsKey('data'), isTrue);

      // data is valid JSON that can be decoded back
      final decoded = jsonDecode(captured['data'] as String);
      expect(decoded['name'], 'London');
    });
  });

  group('getCachedForecast', () {
    test('returns null when nothing in box', () async {
      when(() => mockForecastBox.get('forecast_key')).thenReturn(null);

      final result = await datasource.getCachedForecast('forecast_key');

      expect(result, isNull);
    });

    test('returns forecast when cache is fresh', () async {
      when(() => mockForecastBox.get('forecast_key')).thenReturn({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': jsonEncode(tForecastModel.toJson()),
      });

      final result = await datasource.getCachedForecast('forecast_key');

      expect(result, isNotNull);
      expect(result?.city.name, 'London');
    });

    test('returns null when forecast cache expired', () async {
      when(() => mockForecastBox.get('forecast_key')).thenReturn({
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)).millisecondsSinceEpoch,
        'data': jsonEncode(tForecastModel.toJson()),
      });
      when(() => mockForecastBox.delete('forecast_key')).thenAnswer((_) async {});

      final result = await datasource.getCachedForecast('forecast_key');

      expect(result, isNull);
      verify(() => mockForecastBox.delete('forecast_key')).called(1);
    });

    test('ignores expiration when ignoreExpiration=true', () async {
      when(() => mockForecastBox.get('forecast_key')).thenReturn({
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)).millisecondsSinceEpoch,
        'data': jsonEncode(tForecastModel.toJson()),
      });

      final result = await datasource.getCachedForecast('forecast_key', ignoreExpiration: true);

      expect(result, isNotNull);
    });
  });

  group('cacheForecast', () {
    test('stores forecast data with timestamp', () async {
      when(() => mockForecastBox.put(any(), any())).thenAnswer((_) async {});

      await datasource.cacheForecast('forecast_key', tForecastModel);

      final captured = verify(() => mockForecastBox.put('forecast_key', captureAny()))
          .captured
          .first as Map;
      expect(captured.containsKey('timestamp'), isTrue);
      final decoded = jsonDecode(captured['data'] as String);
      expect(decoded['city']['name'], 'London');
    });
  });
}
