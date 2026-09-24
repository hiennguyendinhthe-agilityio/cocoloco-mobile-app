import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class SearchLocationUseCase {
  final WeatherRepository repository;

  SearchLocationUseCase(this.repository);

  Future<List<LocationEntity>> execute(String query) async {
    if (query.trim().isEmpty) {
      throw ArgumentError('Query cannot be empty');
    }
    return await repository.searchLocation(query);
  }
}

