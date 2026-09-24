import 'package:weather_app/features/weather/domain/entities/location_entity.dart';

abstract interface class RecentSearchesRepository {
  Future<List<LocationEntity>> getRecentSearches();
  Future<void> addRecentSearch(LocationEntity location);
  Future<void> clearRecentSearches();
  Future<void> removeRecentSearch(LocationEntity location);
}
