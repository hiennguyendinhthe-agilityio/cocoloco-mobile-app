// Data Source Implementation — Weather.
//
// Implements [WeatherRemoteDatasource] by delegating to Retrofit clients
// ([WeatherApi] and [GeocodingApi]).
//
// Rules:
//   - Injects the API key from [AppEnv].
//   - Applies default unit (metric) and language (vi).
//   - Catches DioExceptions here and rethrows them as domain exceptions
//     (in a real app), but for this training project we just let them bubble up.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/network/dio_provider.dart';
import 'package:weather_app/env/app_env.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/data/models/location_model.dart';
import 'package:weather_app/features/weather/data/sources/geocoding_api.dart';
import 'package:weather_app/features/weather/data/sources/weather_api.dart';

class WeatherRemoteDatasourceImpl implements WeatherRemoteDatasource {
  final WeatherApi _weatherApi;
  final GeocodingApi _geocodingApi;

  WeatherRemoteDatasourceImpl(this._weatherApi, this._geocodingApi);

  @override
  Future<CurrentWeatherModel> getCurrentWeather(String city, {required String lang}) {
    return _weatherApi.getCurrentWeatherByCity(
      city: city,
      apiKey: AppEnv.owmApiKey,
      units: AppEnv.defaultUnits,
      lang: lang,
    );
  }

  @override
  Future<ForecastModel> getForecast(String city, {required String lang}) {
    return _weatherApi.getForecastByCity(
      city: city,
      apiKey: AppEnv.owmApiKey,
      units: AppEnv.defaultUnits,
      lang: lang,
    );
  }

  @override
  Future<List<LocationModel>> searchLocation(String query) {
    return _geocodingApi.searchLocation(query: query, apiKey: AppEnv.owmApiKey);
  }
}

/// Provides [WeatherRemoteDatasource].
final weatherRemoteDatasourceProvider = Provider<WeatherRemoteDatasource>((
  ref,
) {
  final weatherApi = ref.watch(weatherApiProvider);
  final geocodingApi = ref.watch(geocodingApiProvider);
  return WeatherRemoteDatasourceImpl(weatherApi, geocodingApi);
});
