import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';

final getForecastUseCaseProvider = Provider<GetForecastUseCase>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetForecastUseCase(repository);
});

class GetForecastUseCase {
  final WeatherRepository _repository;

  GetForecastUseCase(this._repository);

  Future<ForecastEntity> execute({required String city, required String lang, bool forceRefresh = false}) {
    if (city.trim().isEmpty) {
      throw ArgumentError('City name cannot be empty.');
    }

    return _repository.getForecast(city: city, lang: lang, forceRefresh: forceRefresh);
  }
}
