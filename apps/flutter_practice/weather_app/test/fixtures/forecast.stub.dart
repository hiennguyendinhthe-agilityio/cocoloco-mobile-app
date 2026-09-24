import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';

/// Predefined [ForecastEntity] stubs for use in forecast-related tests.
///
/// Usage:
/// ```dart
/// when(() => mockGetForecast.execute(city: 'London', lang: 'en'))
///     .thenAnswer((_) async => ForecastStub.london);
/// ```
abstract final class ForecastStub {
  const ForecastStub._();

  /// A fixed reference date for all forecast item dates.
  static final _kBase = DateTime(2024, 7, 15, 12, 0);

  /// Sample forecast items used in [london] and as defaults in [TestUtils].
  static List<ForecastItemEntity> get sampleItems => [
        ForecastItemEntity(
          dateTime: _kBase,
          temperature: 20.0,
          feelsLike: 19.0,
          minTemp: 17.0,
          maxTemp: 23.0,
          condition: 'Clouds',
          iconCode: '04d',
          windSpeed: 5.0,
          humidity: 70,
          pop: 0.1,
        ),
        ForecastItemEntity(
          dateTime: _kBase.add(const Duration(hours: 3)),
          temperature: 22.0,
          feelsLike: 21.0,
          minTemp: 18.0,
          maxTemp: 25.0,
          condition: 'Clouds',
          iconCode: '03d',
          windSpeed: 4.5,
          humidity: 65,
          pop: 0.05,
        ),
        ForecastItemEntity(
          dateTime: _kBase.add(const Duration(hours: 6)),
          temperature: 18.0,
          feelsLike: 17.0,
          minTemp: 15.0,
          maxTemp: 20.0,
          condition: 'Rain',
          iconCode: '10d',
          windSpeed: 7.0,
          humidity: 85,
          pop: 0.8,
        ),
      ];

  /// Standard London 3-day forecast.
  static ForecastEntity get london =>
      ForecastEntity(cityName: 'London', items: sampleItems);

  /// Ho Chi Minh City forecast — for Vietnamese locale tests.
  static ForecastEntity get hoChiMinh =>
      ForecastEntity(cityName: 'Ho Chi Minh City', items: sampleItems);

  /// Empty forecast — for edge case / empty state tests.
  static ForecastEntity get empty =>
      ForecastEntity(cityName: 'Unknown', items: const []);

  /// A forecast with a single rainy item — for precipitation tests.
  static ForecastEntity get rainy => ForecastEntity(
        cityName: 'Bergen',
        items: [
          ForecastItemEntity(
            dateTime: _kBase,
            temperature: 10.0,
            feelsLike: 8.0,
            minTemp: 7.0,
            maxTemp: 12.0,
            condition: 'Rain',
            iconCode: '10d',
            windSpeed: 4.0,
            humidity: 95,
            pop: 0.9,
          ),
        ],
      );
}
