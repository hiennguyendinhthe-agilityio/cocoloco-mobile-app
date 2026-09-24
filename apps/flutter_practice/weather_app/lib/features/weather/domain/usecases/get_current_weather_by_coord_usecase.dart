import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetCurrentWeatherByCoordUseCase {
  final WeatherRepository _repository;

  GetCurrentWeatherByCoordUseCase(this._repository);

  Future<WeatherEntity> execute({
    required double lat,
    required double lon,
    required String lang,
    bool forceRefresh = false,
  }) {
    return _repository.getCurrentWeatherByCoord(
      lat: lat,
      lon: lon,
      lang: lang,
      forceRefresh: forceRefresh,
    );
  }
}

