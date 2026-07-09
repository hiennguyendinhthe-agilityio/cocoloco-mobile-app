import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';

abstract interface class WeatherLocalDatasource {
  Future<CurrentWeatherModel?> getCachedCurrentWeather(String key);
  Future<void> cacheCurrentWeather(String key, CurrentWeatherModel model);

  Future<ForecastModel?> getCachedForecast(String key);
  Future<void> cacheForecast(String key, ForecastModel model);
}

class WeatherLocalDatasourceImpl implements WeatherLocalDatasource {
  final Box _weatherBox;
  final Box _forecastBox;

  // Cache expiration duration
  static const Duration _weatherExpiration = Duration(minutes: 30);
  static const Duration _forecastExpiration = Duration(hours: 3);

  WeatherLocalDatasourceImpl(this._weatherBox, this._forecastBox);

  @override
  Future<CurrentWeatherModel?> getCachedCurrentWeather(String key) async {
    final cachedData = _weatherBox.get(key);
    if (cachedData == null) return null;

    final timestamp = cachedData['timestamp'] as int;
    final saveTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    
    if (DateTime.now().difference(saveTime) > _weatherExpiration) {
      // Cache expired
      await _weatherBox.delete(key);
      return null;
    }

    try {
      final jsonStr = cachedData['data'] as String;
      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return CurrentWeatherModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheCurrentWeather(String key, CurrentWeatherModel model) async {
    await _weatherBox.put(key, {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': jsonEncode(model.toJson()),
    });
  }

  @override
  Future<ForecastModel?> getCachedForecast(String key) async {
    final cachedData = _forecastBox.get(key);
    if (cachedData == null) return null;

    final timestamp = cachedData['timestamp'] as int;
    final saveTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    
    if (DateTime.now().difference(saveTime) > _forecastExpiration) {
      // Cache expired
      await _forecastBox.delete(key);
      return null;
    }

    try {
      final jsonStr = cachedData['data'] as String;
      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ForecastModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheForecast(String key, ForecastModel model) async {
    await _forecastBox.put(key, {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': jsonEncode(model.toJson()),
    });
  }
}

final weatherLocalDatasourceProvider = Provider<WeatherLocalDatasource>((ref) {
  final weatherBox = Hive.box('weather_cache');
  final forecastBox = Hive.box('forecast_cache');
  return WeatherLocalDatasourceImpl(weatherBox, forecastBox);
});
