import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';

class GetForecastByCoordUseCase {
  final WeatherRepository _repository;

  GetForecastByCoordUseCase(this._repository);

  Future<ForecastEntity> execute({
    required double lat,
    required double lon,
    required String lang,
  }) {
    return _repository.getForecastByCoord(
      lat: lat,
      lon: lon,
      lang: lang,
    );
  }
}

final getForecastByCoordUseCaseProvider = Provider<GetForecastByCoordUseCase>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetForecastByCoordUseCase(repository);
});
