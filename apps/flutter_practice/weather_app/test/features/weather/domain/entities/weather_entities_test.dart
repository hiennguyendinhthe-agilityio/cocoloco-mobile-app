import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';

void main() {
  final tNow = DateTime(2024, 7, 15, 12, 0);

  group('WeatherEntity', () {
    WeatherEntity makeWeather({String cityName = 'Hanoi'}) => WeatherEntity(
          cityName: cityName,
          countryCode: 'VN',
          temperature: 32.0,
          feelsLike: 35.0,
          minTemp: 28.0,
          maxTemp: 36.0,
          condition: 'Clear',
          iconCode: '01d',
          humidity: 70,
          windSpeed: 3.0,
          lastUpdated: tNow,
          localTime: tNow,
          sunriseTime: tNow,
          sunsetTime: tNow,
        );

    test('creates entity with all required fields', () {
      final entity = makeWeather();

      expect(entity.cityName, 'Hanoi');
      expect(entity.countryCode, 'VN');
      expect(entity.temperature, 32.0);
      expect(entity.feelsLike, 35.0);
      expect(entity.humidity, 70);
      expect(entity.windSpeed, 3.0);
    });

    test('two identical entities are equal (Freezed value equality)', () {
      final e1 = makeWeather();
      final e2 = makeWeather();

      expect(e1, equals(e2));
    });

    test('copyWith creates updated entity', () {
      final original = makeWeather();
      final updated = original.copyWith(temperature: 40.0, cityName: 'Da Nang');

      expect(updated.temperature, 40.0);
      expect(updated.cityName, 'Da Nang');
      // unchanged fields remain the same
      expect(updated.countryCode, 'VN');
      expect(updated.humidity, 70);
    });

    test('different cityName produces unequal entities', () {
      final hanoi = makeWeather(cityName: 'Hanoi');
      final hcmc = makeWeather(cityName: 'Ho Chi Minh City');

      expect(hanoi, isNot(equals(hcmc)));
    });
  });

  group('ForecastEntity', () {
    final tItem = ForecastItemEntity(
      dateTime: tNow,
      temperature: 30.0,
      feelsLike: 32.0,
      minTemp: 27.0,
      maxTemp: 33.0,
      condition: 'Sunny',
      iconCode: '01d',
      windSpeed: 2.0,
      humidity: 60,
      pop: 0.0,
    );

    test('creates entity with correct fields', () {
      final entity = ForecastEntity(cityName: 'London', items: [tItem]);

      expect(entity.cityName, 'London');
      expect(entity.items.length, 1);
      expect(entity.items.first.temperature, 30.0);
    });

    test('two identical forecast entities are equal', () {
      final f1 = ForecastEntity(cityName: 'London', items: [tItem]);
      final f2 = ForecastEntity(cityName: 'London', items: [tItem]);

      expect(f1, equals(f2));
    });

    test('copyWith updates cityName', () {
      final original = ForecastEntity(cityName: 'London', items: [tItem]);
      final updated = original.copyWith(cityName: 'Paris');

      expect(updated.cityName, 'Paris');
      expect(updated.items, original.items);
    });

    test('ForecastItemEntity pop field', () {
      expect(tItem.pop, 0.0);
      final rainy = tItem.copyWith(pop: 0.8);
      expect(rainy.pop, 0.8);
    });
  });

  group('LocationEntity', () {
    const tLocation = LocationEntity(
      name: 'Ho Chi Minh City',
      lat: 10.8231,
      lon: 106.6297,
      country: 'VN',
      state: 'Ho Chi Minh',
    );

    test('creates entity with correct fields', () {
      expect(tLocation.name, 'Ho Chi Minh City');
      expect(tLocation.lat, 10.8231);
      expect(tLocation.lon, 106.6297);
      expect(tLocation.country, 'VN');
      expect(tLocation.state, 'Ho Chi Minh');
    });

    test('state can be null', () {
      const noState = LocationEntity(
        name: 'London',
        lat: 51.5074,
        lon: -0.1278,
        country: 'GB',
      );

      expect(noState.state, isNull);
    });

    test('two identical locations are equal', () {
      const l1 = LocationEntity(name: 'London', lat: 51.5074, lon: -0.1278, country: 'GB');
      const l2 = LocationEntity(name: 'London', lat: 51.5074, lon: -0.1278, country: 'GB');

      expect(l1, equals(l2));
    });

    test('fromJson / toJson roundtrip', () {
      final json = tLocation.toJson();
      final restored = LocationEntity.fromJson(json);

      expect(restored.name, tLocation.name);
      expect(restored.lat, tLocation.lat);
      expect(restored.state, tLocation.state);
    });
  });
}
