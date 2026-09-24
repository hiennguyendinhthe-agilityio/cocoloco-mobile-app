// Retrofit API client — Weather endpoints.
//
// Base URL: https://api.openweathermap.org/data/2.5
//
// Endpoints:
//   GET /weather  — current weather by city name or coordinates
//   GET /forecast — 5-day / 3-hour forecast
//
// Rules:
//   - NO business logic.
//   - All query params are explicit (no hidden defaults).
//   - apiKey is passed as a query param (OWM standard).

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/env/app_env.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: AppEnv.owmBaseUrl)
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String? baseUrl}) = _WeatherApi;

  // ── Current Weather ────────────────────────────────────────────────────────

  /// Returns current weather for a given [city] name.
  ///
  /// Example: `city = "Da Nang,VN"`
  @GET('/weather')
  Future<CurrentWeatherModel> getCurrentWeatherByCity({
    @Query('q') required String city,
    @Query('appid') required String apiKey,
    @Query('units') required String units,
    @Query('lang') required String lang,
  });

  /// Returns current weather for given [lat] / [lon] coordinates.
  @GET('/weather')
  Future<CurrentWeatherModel> getCurrentWeatherByCoord({
    @Query('lat') required double lat,
    @Query('lon') required double lon,
    @Query('appid') required String apiKey,
    @Query('units') required String units,
    @Query('lang') required String lang,
  });

  // ── Forecast ───────────────────────────────────────────────────────────────

  /// Returns 5-day / 3-hour forecast for a given [city] name.
  @GET('/forecast')
  Future<ForecastModel> getForecastByCity({
    @Query('q') required String city,
    @Query('appid') required String apiKey,
    @Query('units') required String units,
    @Query('lang') required String lang,

    /// Number of timestamps to return (max 40, default 40)
    @Query('cnt') int? cnt,
  });

  /// Returns 5-day / 3-hour forecast for given [lat] / [lon] coordinates.
  @GET('/forecast')
  Future<ForecastModel> getForecastByCoord({
    @Query('lat') required double lat,
    @Query('lon') required double lon,
    @Query('appid') required String apiKey,
    @Query('units') required String units,
    @Query('lang') required String lang,
    @Query('cnt') int? cnt,
  });
}
