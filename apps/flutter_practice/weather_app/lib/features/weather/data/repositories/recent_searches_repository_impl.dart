import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/recent_searches_repository.dart';

class RecentSearchesRepositoryImpl implements RecentSearchesRepository {
  static const _key = 'recent_searches';
  final SharedPreferences _prefs;

  RecentSearchesRepositoryImpl(this._prefs);

  @override
  Future<List<LocationEntity>> getRecentSearches() async {
    final String? jsonString = _prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => LocationEntity.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addRecentSearch(LocationEntity location) async {
    final searches = await getRecentSearches();
    // Remove if already exists (to move it to top)
    searches.removeWhere((e) => e.lat == location.lat && e.lon == location.lon);
    
    // Add to top
    searches.insert(0, location);
    
    // Limit to 5
    if (searches.length > 5) {
      searches.removeLast();
    }
    
    final jsonList = searches.map((e) => e.toJson()).toList();
    await _prefs.setString(_key, jsonEncode(jsonList));
  }

  @override
  Future<void> clearRecentSearches() async {
    await _prefs.remove(_key);
  }

  @override
  Future<void> removeRecentSearch(LocationEntity location) async {
    final searches = await getRecentSearches();
    searches.removeWhere((e) => e.lat == location.lat && e.lon == location.lon);
    final jsonList = searches.map((e) => e.toJson()).toList();
    await _prefs.setString(_key, jsonEncode(jsonList));
  }
}
