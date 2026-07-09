import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/mappers/weather_mapper.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

void main() {
  group('WeatherMapper', () {
    test('should map CurrentWeatherModel to WeatherEntity correctly', () {
      // Arrange
      const tWeatherCondition = WeatherConditionModel(
        id: 804,
        main: 'Clouds',
        description: 'Mây đen u ám', // Simulate Vietnamese response
        icon: '04d',
      );

      const tMain = CurrentMainModel(
        temp: 25.5,
        feelsLike: 27.0,
        tempMin: 24.0,
        tempMax: 26.0,
        pressure: 1012,
        humidity: 80,
      );

      const tWind = WindModel(speed: 3.5, deg: 180);

      const tSys = SysModel(
        country: 'VN',
        sunrise: 1672531200, // 2023-01-01 00:00:00 UTC
        sunset: 1672574400, // 2023-01-01 12:00:00 UTC
      );

      const tModel = CurrentWeatherModel(
        name: 'Ho Chi Minh City',
        weather: [tWeatherCondition],
        main: tMain,
        wind: tWind,
        sys: tSys,
        dt: 1672560000, // 2023-01-01 08:00:00 UTC
        timezone: 25200, // +7 hours in seconds
        id: 1566083,
      );

      // Act
      final result = WeatherMapper.toEntity(tModel);

      // Assert
      expect(result, isA<WeatherEntity>());
      expect(result.cityName, 'Ho Chi Minh City');
      expect(result.countryCode, 'VN');
      expect(result.temperature, 25.5);
      expect(result.condition, 'Mây đen u ám'); // Maps the localized description
      expect(result.iconCode, '04d');
      expect(result.humidity, 80);
      expect(result.windSpeed, 3.5);

      // Check timezone shifting logic
      // UTC time of dt is 08:00:00. Shifted by +7 hours = 15:00:00
      final expectedLocalTime = DateTime.fromMillisecondsSinceEpoch(
        (1672560000 + 25200) * 1000,
        isUtc: true,
      );
      expect(result.localTime, expectedLocalTime);
    });

    test('should provide safe defaults if weather array is empty', () {
      // Arrange
      const tModel = CurrentWeatherModel(
        name: 'Empty City',
        weather: [], // Empty
        main: CurrentMainModel(
          temp: 0,
          feelsLike: 0,
          tempMin: 0,
          tempMax: 0,
          pressure: 0,
          humidity: 0,
        ),
        wind: WindModel(speed: 0, deg: 0),
        sys: SysModel(country: 'US', sunrise: 0, sunset: 0),
        dt: 0,
        timezone: 0,
        id: 1,
      );

      // Act
      final result = WeatherMapper.toEntity(tModel);

      // Assert
      expect(result.condition, 'Unknown');
      expect(result.iconCode, '01d');
    });
  });
}
