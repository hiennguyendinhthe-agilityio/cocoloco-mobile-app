import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/mappers/weather_mapper.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';

void main() {
  final tModel = const CurrentWeatherModel(
    name: 'Da Nang',
    dt: 1672570000,
    timezone: 25200, // UTC+7 (Vietnam)
    id: 1580240,
    weather: [
      WeatherConditionModel(id: 800, main: 'Clear', description: 'clear sky', icon: '01d'),
    ],
    main: CurrentMainModel(
      temp: 32.0,
      feelsLike: 35.0,
      tempMin: 28.0,
      tempMax: 36.0,
      pressure: 1010,
      humidity: 75,
    ),
    wind: WindModel(speed: 4.5, deg: 135),
    sys: SysModel(country: 'VN', sunrise: 1672543200, sunset: 1672589400),
  );

  group('WeatherMapper - toEntity', () {
    test('maps city name and country code', () {
      final entity = WeatherMapper.toEntity(tModel);
      expect(entity.cityName, 'Da Nang');
      expect(entity.countryCode, 'VN');
    });

    test('maps temperature fields correctly', () {
      final entity = WeatherMapper.toEntity(tModel);
      expect(entity.temperature, 32.0);
      expect(entity.feelsLike, 35.0);
      expect(entity.minTemp, 28.0);
      expect(entity.maxTemp, 36.0);
    });

    test('maps humidity and windSpeed correctly', () {
      final entity = WeatherMapper.toEntity(tModel);
      expect(entity.humidity, 75);
      expect(entity.windSpeed, 4.5);
    });

    test('maps weather description and icon from first weather item', () {
      final entity = WeatherMapper.toEntity(tModel);
      expect(entity.condition, 'clear sky');
      expect(entity.iconCode, '01d');
    });

    test('uses Unknown/01d defaults when weather array is empty', () {
      final modelNoWeather = tModel.copyWith(weather: []);
      final entity = WeatherMapper.toEntity(modelNoWeather);
      expect(entity.condition, 'Unknown');
      expect(entity.iconCode, '01d');
    });

    test('converts Unix dt to lastUpdated DateTime', () {
      final entity = WeatherMapper.toEntity(tModel);
      final expected = DateTime.fromMillisecondsSinceEpoch(1672570000 * 1000);
      expect(entity.lastUpdated, expected);
    });

    test('applies timezone offset to localTime', () {
      final entity = WeatherMapper.toEntity(tModel);
      final utc = DateTime.fromMillisecondsSinceEpoch(1672570000 * 1000, isUtc: true);
      final expected = utc.add(const Duration(seconds: 25200));
      expect(entity.localTime, expected);
    });

    test('applies timezone offset to sunriseTime', () {
      final entity = WeatherMapper.toEntity(tModel);
      final utc = DateTime.fromMillisecondsSinceEpoch(1672543200 * 1000, isUtc: true);
      final expected = utc.add(const Duration(seconds: 25200));
      expect(entity.sunriseTime, expected);
    });

    test('applies timezone offset to sunsetTime', () {
      final entity = WeatherMapper.toEntity(tModel);
      final utc = DateTime.fromMillisecondsSinceEpoch(1672589400 * 1000, isUtc: true);
      final expected = utc.add(const Duration(seconds: 25200));
      expect(entity.sunsetTime, expected);
    });

    test('handles zero timezone (UTC) offset correctly', () {
      final modelUtc = tModel.copyWith(timezone: 0);
      final entity = WeatherMapper.toEntity(modelUtc);
      final expected = DateTime.fromMillisecondsSinceEpoch(1672570000 * 1000, isUtc: true);
      expect(entity.localTime.millisecondsSinceEpoch, expected.millisecondsSinceEpoch);
    });
  });
}
