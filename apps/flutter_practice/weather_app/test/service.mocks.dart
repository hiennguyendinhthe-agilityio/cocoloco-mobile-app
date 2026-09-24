import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_by_coord_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_by_coord_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/search_location_usecase.dart';
import 'package:weather_app/features/weather/data/datasources/remote/weather_api.dart';
import 'package:weather_app/features/weather/data/datasources/remote/geocoding_api.dart';
import 'package:weather_app/features/weather/presentation/providers/location_service_provider.dart';

import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';
import 'package:weather_app/core/services/analytics_service.dart';

// ---------------------------------------------------------------------------
// Use Case Mocks
// ---------------------------------------------------------------------------

class MockGetCurrentWeatherUseCase extends Mock
    implements GetCurrentWeatherUseCase {}

class MockGetCurrentWeatherByCoordUseCase extends Mock
    implements GetCurrentWeatherByCoordUseCase {}

class MockGetForecastUseCase extends Mock implements GetForecastUseCase {}

class MockGetForecastByCoordUseCase extends Mock
    implements GetForecastByCoordUseCase {}

class MockSearchLocationUseCase extends Mock implements SearchLocationUseCase {}

// ---------------------------------------------------------------------------
// API Source Mocks (Retrofit)
// ---------------------------------------------------------------------------

class MockWeatherApi extends Mock implements WeatherApi {}

class MockGeocodingApi extends Mock implements GeocodingApi {}

// ---------------------------------------------------------------------------
// Service Mocks
// ---------------------------------------------------------------------------

class MockLocationService extends Mock implements LocationService {}

// ---------------------------------------------------------------------------
// Provider/Notifier Mocks
// ---------------------------------------------------------------------------

class MockWeatherNotifier extends AsyncNotifier<WeatherEntity?>
    with Mock
    implements WeatherNotifier {
  final WeatherEntity? _initial;
  MockWeatherNotifier([this._initial]);

  @override
  FutureOr<WeatherEntity?> build() => _initial;
}

class MockForecastNotifier extends AsyncNotifier<ForecastEntity?>
    with Mock
    implements ForecastNotifier {
  final ForecastEntity? _initial;
  MockForecastNotifier([this._initial]);

  @override
  FutureOr<ForecastEntity?> build() => _initial;
}


class MockRecentSearchesNotifier
    extends AsyncNotifier<List<LocationEntity>>
    with Mock
    implements RecentSearchesNotifier {
  final List<LocationEntity>? _initial;
  MockRecentSearchesNotifier([this._initial]);

  @override
  FutureOr<List<LocationEntity>> build() => _initial ?? [];
}

class MockAnalyticsService extends Mock implements AnalyticsService {}
