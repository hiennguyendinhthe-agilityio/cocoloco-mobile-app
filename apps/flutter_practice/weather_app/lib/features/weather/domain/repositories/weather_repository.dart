// Domain Repository Interface — Weather.
//
// Rules:
//   - PURE Dart. No network imports (no Dio, no Retrofit).
//   - Returns Domain Entities ([WeatherEntity]), NEVER Data Models.
//   - Defines WHAT the app can do, not HOW it does it.

import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

abstract interface class WeatherRepository {
  Future<WeatherEntity> getCurrentWeather({required String city, required String lang});
  Future<ForecastEntity> getForecast({required String city, required String lang});
}
