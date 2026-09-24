// Retrofit API client — Geocoding / City Search.
//
// Base URL: https://api.openweathermap.org/geo/1.0
//
// Endpoint:
//   GET /direct — search cities by name, returns up to [limit] results
//
// Note: Different base URL from WeatherApi → separate Retrofit client.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/env/app_env.dart';
import 'package:weather_app/features/weather/data/models/location_model.dart';

part 'geocoding_api.g.dart';

@RestApi(baseUrl: AppEnv.owmGeoBaseUrl)
abstract class GeocodingApi {
  factory GeocodingApi(Dio dio, {String? baseUrl}) = _GeocodingApi;

  // ── City Search ────────────────────────────────────────────────────────────

  /// Search for cities matching [query].
  ///
  /// [query] format: `"city name"`, `"city name,country code"`,
  ///                 `"city,state,country"` (US only for state).
  /// [limit] max results returned (1–5, default 5).
  @GET('/direct')
  Future<List<LocationModel>> searchLocation({
    @Query('q') required String query,
    @Query('appid') required String apiKey,
    @Query('limit') int? limit,
  });
}
