import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

/// Predefined [WeatherEntity] stubs for use in weather-related tests.
///
/// Using stubs avoids creating the same objects repeatedly across test files
/// and keeps test data consistent and readable.
///
/// Usage:
/// ```dart
/// when(() => mockRepository.getCurrentWeather(city: 'London', lang: 'en'))
///     .thenAnswer((_) async => WeatherStub.london);
/// ```
abstract final class WeatherStub {
  const WeatherStub._();

  /// Standard London weather — used in most generic weather tests.
  static final london = WeatherEntity(
    cityName: 'London',
    countryCode: 'GB',
    temperature: 20.0,
    feelsLike: 19.5,
    minTemp: 18.0,
    maxTemp: 22.0,
    condition: 'Clouds',
    iconCode: '04d',
    humidity: 70,
    windSpeed: 5.0,
    lastUpdated: DateTime(2024, 7, 15, 12, 0),
    localTime: DateTime(2024, 7, 15, 12, 0),
    sunriseTime: DateTime(2024, 7, 15, 6, 0),
    sunsetTime: DateTime(2024, 7, 15, 20, 0),
  );

  /// Hanoi weather — used in locale/Vietnamese tests.
  static final hanoi = WeatherEntity(
    cityName: 'Hà Nội',
    countryCode: 'VN',
    temperature: 35.0,
    feelsLike: 38.0,
    minTemp: 30.0,
    maxTemp: 38.0,
    condition: 'Clear',
    iconCode: '01d',
    humidity: 80,
    windSpeed: 3.0,
    lastUpdated: DateTime(2024, 7, 15, 12, 0),
    localTime: DateTime(2024, 7, 15, 19, 0),
    sunriseTime: DateTime(2024, 7, 15, 5, 30),
    sunsetTime: DateTime(2024, 7, 15, 18, 30),
  );

  /// Ho Chi Minh City weather.
  static final hoChiMinh = WeatherEntity(
    cityName: 'Ho Chi Minh City',
    countryCode: 'VN',
    temperature: 32.0,
    feelsLike: 36.0,
    minTemp: 28.0,
    maxTemp: 34.0,
    condition: 'Thunderstorm',
    iconCode: '11d',
    humidity: 90,
    windSpeed: 6.5,
    lastUpdated: DateTime(2024, 7, 15, 12, 0),
    localTime: DateTime(2024, 7, 15, 19, 0),
    sunriseTime: DateTime(2024, 7, 15, 5, 45),
    sunsetTime: DateTime(2024, 7, 15, 18, 15),
  );

  /// Cold snowy weather — for snow overlay tests.
  static final snowy = WeatherEntity(
    cityName: 'Oslo',
    countryCode: 'NO',
    temperature: -5.0,
    feelsLike: -10.0,
    minTemp: -8.0,
    maxTemp: -2.0,
    condition: 'Snow',
    iconCode: '13d',
    humidity: 90,
    windSpeed: 2.0,
    lastUpdated: DateTime(2024, 1, 15, 12, 0),
    localTime: DateTime(2024, 1, 15, 12, 0),
    sunriseTime: DateTime(2024, 1, 15, 8, 0),
    sunsetTime: DateTime(2024, 1, 15, 16, 0),
  );

  /// Rainy weather — for rain overlay tests.
  static final rainy = WeatherEntity(
    cityName: 'Bergen',
    countryCode: 'NO',
    temperature: 10.0,
    feelsLike: 8.0,
    minTemp: 7.0,
    maxTemp: 12.0,
    condition: 'Rain',
    iconCode: '10d',
    humidity: 95,
    windSpeed: 4.0,
    lastUpdated: DateTime(2024, 7, 15, 12, 0),
    localTime: DateTime(2024, 7, 15, 12, 0),
    sunriseTime: DateTime(2024, 7, 15, 5, 0),
    sunsetTime: DateTime(2024, 7, 15, 21, 0),
  );

  /// Hot sunny weather — for sun rays overlay tests.
  static final hotSunny = WeatherEntity(
    cityName: 'Dubai',
    countryCode: 'AE',
    temperature: 42.0,
    feelsLike: 45.0,
    minTemp: 38.0,
    maxTemp: 45.0,
    condition: 'Clear',
    iconCode: '01d',
    humidity: 30,
    windSpeed: 2.0,
    lastUpdated: DateTime(2024, 7, 15, 12, 0),
    localTime: DateTime(2024, 7, 15, 15, 0),
    sunriseTime: DateTime(2024, 7, 15, 5, 30),
    sunsetTime: DateTime(2024, 7, 15, 19, 30),
  );

  /// Night weather — for shooting star overlay tests.
  static final night = WeatherEntity(
    cityName: 'Paris',
    countryCode: 'FR',
    temperature: 15.0,
    feelsLike: 13.0,
    minTemp: 12.0,
    maxTemp: 18.0,
    condition: 'Clear',
    iconCode: '01n',
    humidity: 60,
    windSpeed: 2.0,
    lastUpdated: DateTime(2024, 7, 15, 23, 0),
    localTime: DateTime(2024, 7, 15, 23, 0),
    sunriseTime: DateTime(2024, 7, 15, 6, 0),
    sunsetTime: DateTime(2024, 7, 15, 21, 30),
  );
}
