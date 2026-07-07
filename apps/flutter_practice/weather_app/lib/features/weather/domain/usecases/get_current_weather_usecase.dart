// Use Case — Get Current Weather.
//
// Rules:
//   - Single Responsibility: Each use case does exactly one thing.
//   - Belongs to the Domain layer.
//   - Interacts with Repositories, never directly with Data Sources.
//   - Can be invoked by UI controllers/Riverpod Notifiers.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository _repository;

  GetCurrentWeatherUseCase(this._repository);

  /// Executes the use case.
  /// Throws exceptions if the repository fails (can be caught by the caller).
  Future<WeatherEntity> execute({required String city, required String lang}) {
    if (city.trim().isEmpty) {
      throw ArgumentError('City name cannot be empty.');
    }

    return _repository.getCurrentWeather(city: city, lang: lang);
  }
}

/// Provides [GetCurrentWeatherUseCase].
final getCurrentWeatherUseCaseProvider = Provider<GetCurrentWeatherUseCase>((
  ref,
) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetCurrentWeatherUseCase(repository);
});
