import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/mappers/weather_mapper.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

void main() {
  group('WeatherMapper', () {
    test('should map CurrentWeatherModel to WeatherEntity correctly', () {
      // Arrange
      final model = CurrentWeatherModel(
        weather: const [WeatherConditionModel(id: 800, main: 'Clear', description: 'clear sky', icon: '01d')],
        main: const CurrentMainModel(
          temp: 30.0,
          feelsLike: 32.0,
          tempMin: 29.0,
          tempMax: 31.0,
          pressure: 1010,
          humidity: 70,
        ),
        wind: const WindModel(speed: 3.5, deg: 180),
        dt: 1625097600, // UTC: 2021-07-01 00:00:00
        sys: const SysModel(
          country: 'VN',
          sunrise: 1625090000,
          sunset: 1625140000,
        ),
        timezone: 25200, // UTC+7
        id: 1581130,
        name: 'Hanoi',
      );

      // Act
      final result = WeatherMapper.toEntity(model);

      // Assert
      expect(result, isA<WeatherEntity>());
      expect(result.cityName, 'Hanoi');
      expect(result.countryCode, 'VN');
      expect(result.temperature, 30.0);
      expect(result.feelsLike, 32.0);
      expect(result.condition, 'clear sky');
      expect(result.iconCode, '01d');
      expect(result.humidity, 70);
      expect(result.windSpeed, 3.5);
      
      // Timezone check: 1625097600 (UTC 00:00) + 25200 (7 hours) = 07:00 local time
      expect(result.localTime.hour, 7);
      expect(result.localTime.minute, 0);
    });
  });
}
