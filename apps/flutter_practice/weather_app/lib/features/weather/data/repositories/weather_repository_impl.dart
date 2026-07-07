// Repository Implementation — Weather.
//
// Rules:
//   - Implements the Domain contract ([WeatherRepository]).
//   - Orchestrates Data Sources and Mappers.
//   - NO business logic, only data fetching and mapping.
//   - Hides the remote/local data source complexity from the rest of the app.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource_impl.dart';
import 'package:weather_app/features/weather/data/mappers/forecast_mapper.dart';
import 'package:weather_app/features/weather/data/mappers/weather_mapper.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource _remoteDatasource;

  WeatherRepositoryImpl(this._remoteDatasource);

  @override
  Future<WeatherEntity> getCurrentWeather({required String city, required String lang}) async {
    //
    final model = await _remoteDatasource.getCurrentWeather(city, lang: lang);

    return WeatherMapper.toEntity(model);
  }

  @override
  Future<ForecastEntity> getForecast({required String city, required String lang}) async {
    final model = await _remoteDatasource.getForecast(city, lang: lang);
    return ForecastMapper.toEntity(model);
  }
}

/// Provides [WeatherRepository].
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final remoteDatasource = ref.watch(weatherRemoteDatasourceProvider);
  return WeatherRepositoryImpl(remoteDatasource);
});
