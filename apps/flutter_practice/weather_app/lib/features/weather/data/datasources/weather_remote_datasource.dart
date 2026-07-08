// Data Source interface — Weather.
//
// Defines the contract for fetching weather and location data.

import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/models/location_model.dart';

abstract interface class WeatherRemoteDatasource {
  /// Fetches current weather for a specific city.
  Future<CurrentWeatherModel> getCurrentWeather(String city, {required String lang});

  /// Fetches current weather by coordinates.
  Future<CurrentWeatherModel> getCurrentWeatherByCoord(double lat, double lon, {required String lang});

  /// Fetches 5-day / 3-hour forecast for a specific city.
  Future<ForecastModel> getForecast(String city, {required String lang});

  /// Fetches 5-day / 3-hour forecast by coordinates.
  Future<ForecastModel> getForecastByCoord(double lat, double lon, {required String lang});

  /// Searches for cities matching a query.
  Future<List<LocationModel>> searchLocation(String query);
}
