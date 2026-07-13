import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/mappers/forecast_mapper.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';

void main() {
  group('ForecastMapper', () {
    // Helper: build a single ForecastItem
    ForecastItem makeForecastItem({
      int dt = 1672560000, // 2023-01-01 08:00 UTC
      double temp = 25.0,
      double feelsLike = 26.0,
      double tempMin = 23.0,
      double tempMax = 27.0,
      int humidity = 80,
      double windSpeed = 4.0,
      double pop = 0.3,
      String description = 'clear sky',
      String icon = '01d',
    }) =>
        ForecastItem(
          dt: dt,
          main: ForecastMainModel(
            temp: temp,
            feelsLike: feelsLike,
            tempMin: tempMin,
            tempMax: tempMax,
            pressure: 1012,
            humidity: humidity,
          ),
          weather: [
            ForecastWeatherDesc(
              id: 800,
              main: 'Clear',
              description: description,
              icon: icon,
            ),
          ],
          wind: ForecastWindModel(speed: windSpeed, deg: 90),
          dtTxt: '2023-01-01 08:00:00',
          pop: pop,
        );

    final tModel = ForecastModel(
      list: [makeForecastItem()],
      city: const ForecastCityModel(
        id: 2643743,
        name: 'London',
        country: 'GB',
        timezone: 0, // UTC+0
      ),
    );

    test('toEntity should map city name correctly', () {
      final result = ForecastMapper.toEntity(tModel);

      expect(result, isA<ForecastEntity>());
      expect(result.cityName, 'London');
    });

    test('toEntity should map all forecast items', () {
      final result = ForecastMapper.toEntity(tModel);

      expect(result.items.length, 1);
    });

    test('toEntity should map temperature data correctly', () {
      final result = ForecastMapper.toEntity(tModel);
      final item = result.items.first;

      expect(item.temperature, 25.0);
      expect(item.feelsLike, 26.0);
      expect(item.minTemp, 23.0);
      expect(item.maxTemp, 27.0);
      expect(item.humidity, 80);
      expect(item.windSpeed, 4.0);
      expect(item.pop, 0.3);
    });

    test('toEntity should map weather description and icon correctly', () {
      final result = ForecastMapper.toEntity(tModel);
      final item = result.items.first;

      expect(item.condition, 'clear sky');
      expect(item.iconCode, '01d');
    });

    test('toEntity should apply timezone offset to dateTime', () {
      // timezone = +7h = 25200 seconds
      final modelWithTz = ForecastModel(
        list: [makeForecastItem(dt: 1672560000)], // 08:00 UTC
        city: const ForecastCityModel(
          id: 1,
          name: 'Ho Chi Minh City',
          country: 'VN',
          timezone: 25200, // +7h
        ),
      );

      final result = ForecastMapper.toEntity(modelWithTz);
      final item = result.items.first;

      // 08:00 UTC + 7h = 15:00 local
      expect(item.dateTime.hour, 15);
    });

    test('toEntity should use "Unknown" and "01d" defaults if weather list is empty', () {
      final modelEmptyWeather = ForecastModel(
        list: [
          ForecastItem(
            dt: 1672560000,
            main: const ForecastMainModel(
              temp: 20.0,
              feelsLike: 20.0,
              tempMin: 18.0,
              tempMax: 22.0,
              pressure: 1010,
              humidity: 60,
            ),
            weather: [], // Empty!
            wind: const ForecastWindModel(speed: 2.0, deg: 0),
            dtTxt: '2023-01-01 08:00:00',
          ),
        ],
        city: const ForecastCityModel(
          id: 1,
          name: 'Test City',
          country: 'TC',
          timezone: 0,
        ),
      );

      final result = ForecastMapper.toEntity(modelEmptyWeather);
      final item = result.items.first;

      expect(item.condition, 'Unknown');
      expect(item.iconCode, '01d');
    });

    test('toEntity should handle empty items list', () {
      final emptyModel = ForecastModel(
        list: [],
        city: const ForecastCityModel(
          id: 1,
          name: 'Empty City',
          country: 'EC',
          timezone: 0,
        ),
      );

      final result = ForecastMapper.toEntity(emptyModel);

      expect(result.items, isEmpty);
    });
  });
}
