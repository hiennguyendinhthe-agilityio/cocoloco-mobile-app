import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/location_model.dart';

void main() {
  const tJson = {
    'name': 'Ho Chi Minh City',
    'lat': 10.8231,
    'lon': 106.6297,
    'country': 'VN',
    'state': 'Ho Chi Minh',
  };

  group('LocationModel - fromJson', () {
    test('parses all fields correctly', () {
      final model = LocationModel.fromJson(tJson);

      expect(model.name, 'Ho Chi Minh City');
      expect(model.lat, 10.8231);
      expect(model.lon, 106.6297);
      expect(model.country, 'VN');
      expect(model.state, 'Ho Chi Minh');
    });

    test('parses null state correctly', () {
      final json = Map<String, dynamic>.from(tJson)..remove('state');
      final model = LocationModel.fromJson(json);

      expect(model.state, isNull);
    });
  });

  group('LocationModel - toJson roundtrip', () {
    test('serializes and deserializes correctly', () {
      final original = LocationModel.fromJson(tJson);
      // Use json string to convert Freezed objects → plain Maps
      final json = jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final restored = LocationModel.fromJson(json);

      expect(restored.name, original.name);
      expect(restored.lat, original.lat);
      expect(restored.state, original.state);
    });
  });

  group('LocationModel - Freezed equality', () {
    test('two models with same data are equal', () {
      final m1 = LocationModel.fromJson(tJson);
      final m2 = LocationModel.fromJson(tJson);
      expect(m1, equals(m2));
    });
  });

  group('LocationModelX - toEntity', () {
    test('converts to LocationEntity with all fields', () {
      final model = LocationModel.fromJson(tJson);
      final entity = model.toEntity();

      expect(entity.name, 'Ho Chi Minh City');
      expect(entity.lat, 10.8231);
      expect(entity.lon, 106.6297);
      expect(entity.country, 'VN');
      expect(entity.state, 'Ho Chi Minh');
    });

    test('toEntity preserves null state', () {
      const model = LocationModel(
        name: 'London',
        lat: 51.5074,
        lon: -0.1278,
        country: 'GB',
      );
      final entity = model.toEntity();
      expect(entity.state, isNull);
    });
  });
}
