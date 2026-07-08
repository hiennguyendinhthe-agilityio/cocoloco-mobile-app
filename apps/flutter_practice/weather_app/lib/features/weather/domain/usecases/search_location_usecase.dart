import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class SearchLocationUseCase {
  final WeatherRepository repository;

  SearchLocationUseCase(this.repository);

  Future<List<LocationEntity>> execute(String query) async {
    return await repository.searchLocation(query);
  }
}

final searchLocationUseCaseProvider = Provider<SearchLocationUseCase>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return SearchLocationUseCase(repository);
});
