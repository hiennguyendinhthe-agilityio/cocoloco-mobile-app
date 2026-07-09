// Repository Implementation — Weather.
//
// Rules:
//   - Implements the Domain contract ([WeatherRepository]).
//   - Orchestrates Data Sources and Mappers.
//   - NO business logic, only data fetching and mapping.
//   - Hides the remote/local data source complexity from the rest of the app.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource_impl.dart';
import 'package:weather_app/features/weather/data/mappers/forecast_mapper.dart';
import 'package:weather_app/features/weather/data/mappers/weather_mapper.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/data/models/location_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource _remoteDatasource;
  final WeatherLocalDatasource _localDatasource;

  WeatherRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<WeatherEntity> getCurrentWeather({required String city, required String lang, bool forceRefresh = false}) async {
    final cacheKey = 'city_${city.toLowerCase()}_$lang';
    
    // 1. Try to get from local cache
    if (!forceRefresh) {
      final cachedModel = await _localDatasource.getCachedCurrentWeather(cacheKey);
      if (cachedModel != null) {
        return WeatherMapper.toEntity(cachedModel);
      }
    }

    // 2. If no cache or expired, fetch from remote
    final model = await _remoteDatasource.getCurrentWeather(city, lang: lang);

    // 3. Save to local cache
    await _localDatasource.cacheCurrentWeather(cacheKey, model);

    return WeatherMapper.toEntity(model);
  }

  @override
  Future<WeatherEntity> getCurrentWeatherByCoord({required double lat, required double lon, required String lang, bool forceRefresh = false}) async {
    final cacheKey = 'coord_${lat.toStringAsFixed(3)}_${lon.toStringAsFixed(3)}_$lang';
    
    if (!forceRefresh) {
      final cachedModel = await _localDatasource.getCachedCurrentWeather(cacheKey);
      if (cachedModel != null) {
        return WeatherMapper.toEntity(cachedModel);
      }
    }

    final model = await _remoteDatasource.getCurrentWeatherByCoord(lat, lon, lang: lang);
    await _localDatasource.cacheCurrentWeather(cacheKey, model);

    return WeatherMapper.toEntity(model);
  }

  @override
  Future<ForecastEntity> getForecast({required String city, required String lang, bool forceRefresh = false}) async {
    final cacheKey = 'city_${city.toLowerCase()}_$lang';
    
    if (!forceRefresh) {
      final cachedModel = await _localDatasource.getCachedForecast(cacheKey);
      if (cachedModel != null) {
        return ForecastMapper.toEntity(cachedModel);
      }
    }

    final model = await _remoteDatasource.getForecast(city, lang: lang);
    await _localDatasource.cacheForecast(cacheKey, model);

    return ForecastMapper.toEntity(model);
  }

  @override
  Future<ForecastEntity> getForecastByCoord({required double lat, required double lon, required String lang, bool forceRefresh = false}) async {
    final cacheKey = 'coord_${lat.toStringAsFixed(3)}_${lon.toStringAsFixed(3)}_$lang';
    
    if (!forceRefresh) {
      final cachedModel = await _localDatasource.getCachedForecast(cacheKey);
      if (cachedModel != null) {
        return ForecastMapper.toEntity(cachedModel);
      }
    }

    final model = await _remoteDatasource.getForecastByCoord(lat, lon, lang: lang);
    await _localDatasource.cacheForecast(cacheKey, model);

    return ForecastMapper.toEntity(model);
  }

  @override
  Future<List<LocationEntity>> searchLocation(String query) async {
    // Geocoding results are not heavily cached as they don't expire quickly,
    // but typically we don't cache search queries to save space.
    final models = await _remoteDatasource.searchLocation(query);
    return models.map((e) => e.toEntity()).toList();
  }
}

/// Provides [WeatherRepository].
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final remoteDatasource = ref.watch(weatherRemoteDatasourceProvider);
  final localDatasource = ref.watch(weatherLocalDatasourceProvider);
  return WeatherRepositoryImpl(remoteDatasource, localDatasource);
});
