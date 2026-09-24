import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/core/network/dio_provider.dart';
import 'package:weather_app/core/storage/preferences_service.dart';
// Data Sources
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource_impl.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource_impl.dart';
import 'package:weather_app/features/weather/data/repositories/recent_searches_repository_impl.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
// Repositories
import 'package:weather_app/features/weather/domain/repositories/recent_searches_repository.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
// Use Cases
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_by_coord_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_by_coord_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/search_location_usecase.dart';

// --- Data Sources ---
final weatherLocalDatasourceProvider = Provider<WeatherLocalDatasource>((ref) {
  final weatherBox = Hive.box('weather_cache');
  final forecastBox = Hive.box('forecast_cache');
  return WeatherLocalDatasourceImpl(weatherBox, forecastBox);
});

final weatherRemoteDatasourceProvider = Provider<WeatherRemoteDatasource>((
  ref,
) {
  final weatherApi = ref.watch(weatherApiProvider);
  final geocodingApi = ref.watch(geocodingApiProvider);
  return WeatherRemoteDatasourceImpl(weatherApi, geocodingApi);
});

// --- Repositories ---
final recentSearchesRepositoryProvider = Provider<RecentSearchesRepository>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return RecentSearchesRepositoryImpl(prefs);
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final remoteDatasource = ref.watch(weatherRemoteDatasourceProvider);
  final localDatasource = ref.watch(weatherLocalDatasourceProvider);
  return WeatherRepositoryImpl(remoteDatasource, localDatasource);
});

// --- Use Cases ---
final getCurrentWeatherUseCaseProvider = Provider<GetCurrentWeatherUseCase>((
  ref,
) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetCurrentWeatherUseCase(repository);
});

final getCurrentWeatherByCoordUseCaseProvider =
    Provider<GetCurrentWeatherByCoordUseCase>((ref) {
      final repository = ref.watch(weatherRepositoryProvider);
      return GetCurrentWeatherByCoordUseCase(repository);
    });

final getForecastUseCaseProvider = Provider<GetForecastUseCase>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetForecastUseCase(repository);
});

final getForecastByCoordUseCaseProvider = Provider<GetForecastByCoordUseCase>((
  ref,
) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetForecastByCoordUseCase(repository);
});

final searchLocationUseCaseProvider = Provider<SearchLocationUseCase>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return SearchLocationUseCase(repository);
});
