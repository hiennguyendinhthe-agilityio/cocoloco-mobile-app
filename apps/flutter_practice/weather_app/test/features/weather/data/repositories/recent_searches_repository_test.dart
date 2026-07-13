import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/features/weather/data/repositories/recent_searches_repository.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late RecentSearchesRepositoryImpl repository;
  late MockSharedPreferences mockPrefs;

  const tKey = 'recent_searches';

  final tLocation1 = const LocationEntity(name: 'London', lat: 51.5074, lon: -0.1278, country: 'GB');
  final tLocation2 = const LocationEntity(name: 'Paris', lat: 48.8566, lon: 2.3522, country: 'FR');

  setUp(() {
    mockPrefs = MockSharedPreferences();
    repository = RecentSearchesRepositoryImpl(mockPrefs);
  });

  group('getRecentSearches', () {
    test('should return empty list when no data is saved', () async {
      when(() => mockPrefs.getString(tKey)).thenReturn(null);
      final result = await repository.getRecentSearches();
      expect(result, isEmpty);
    });

    test('should return empty list when json string is empty', () async {
      when(() => mockPrefs.getString(tKey)).thenReturn('');
      final result = await repository.getRecentSearches();
      expect(result, isEmpty);
    });

    test('should return list of LocationEntity when data is present', () async {
      final jsonList = [tLocation1.toJson(), tLocation2.toJson()];
      when(() => mockPrefs.getString(tKey)).thenReturn(jsonEncode(jsonList));

      final result = await repository.getRecentSearches();
      expect(result.length, 2);
      expect(result[0].name, 'London');
      expect(result[1].name, 'Paris');
    });

    test('should return empty list when json parsing fails', () async {
      when(() => mockPrefs.getString(tKey)).thenReturn('invalid_json');
      final result = await repository.getRecentSearches();
      expect(result, isEmpty);
    });
  });

  group('addRecentSearch', () {
    test('should add location to empty list', () async {
      when(() => mockPrefs.getString(tKey)).thenReturn(null);
      when(() => mockPrefs.setString(tKey, any())).thenAnswer((_) async => true);

      await repository.addRecentSearch(tLocation1);

      verify(() => mockPrefs.setString(tKey, jsonEncode([tLocation1.toJson()]))).called(1);
    });

    test('should move existing location to top if already exists', () async {
      final initialList = [tLocation2.toJson(), tLocation1.toJson()];
      when(() => mockPrefs.getString(tKey)).thenReturn(jsonEncode(initialList));
      when(() => mockPrefs.setString(tKey, any())).thenAnswer((_) async => true);

      await repository.addRecentSearch(tLocation1);

      final expectedList = [tLocation1.toJson(), tLocation2.toJson()];
      verify(() => mockPrefs.setString(tKey, jsonEncode(expectedList))).called(1);
    });

    test('should limit list to 5 items', () async {
      final initialLocations = List.generate(
        5,
        (i) => LocationEntity(name: 'City $i', lat: i.toDouble(), lon: i.toDouble(), country: 'XX'),
      );
      final initialJson = initialLocations.map((e) => e.toJson()).toList();
      
      when(() => mockPrefs.getString(tKey)).thenReturn(jsonEncode(initialJson));
      when(() => mockPrefs.setString(tKey, any())).thenAnswer((_) async => true);

      final newLocation = const LocationEntity(name: 'New City', lat: 99.0, lon: 99.0, country: 'YY');
      await repository.addRecentSearch(newLocation);

      final captured = verify(() => mockPrefs.setString(tKey, captureAny())).captured.first as String;
      final savedList = jsonDecode(captured) as List;
      
      expect(savedList.length, 5);
      expect(savedList[0]['name'], 'New City');
      // The last one (City 4) should be removed
      expect(savedList.last['name'], 'City 3');
    });
  });

  group('clearRecentSearches', () {
    test('should remove key from preferences', () async {
      when(() => mockPrefs.remove(tKey)).thenAnswer((_) async => true);

      await repository.clearRecentSearches();

      verify(() => mockPrefs.remove(tKey)).called(1);
    });
  });

  group('removeRecentSearch', () {
    test('should remove location from list', () async {
      final initialList = [tLocation1.toJson(), tLocation2.toJson()];
      when(() => mockPrefs.getString(tKey)).thenReturn(jsonEncode(initialList));
      when(() => mockPrefs.setString(tKey, any())).thenAnswer((_) async => true);

      await repository.removeRecentSearch(tLocation1);

      verify(() => mockPrefs.setString(tKey, jsonEncode([tLocation2.toJson()]))).called(1);
    });
  });
}
