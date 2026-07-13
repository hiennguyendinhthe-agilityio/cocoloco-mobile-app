import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/current_weather_model.dart';

void main() {
  // ─── Sample raw JSON mimicking OWM API response ───────────────────────────
  const tWeatherJson = {
    'id': 2643743,
    'name': 'London',
    'dt': 1672560000,
    'timezone': 0,
    'weather': [
      {
        'id': 804,
        'main': 'Clouds',
        'description': 'overcast clouds',
        'icon': '04d',
      }
    ],
    'main': {
      'temp': 10.5,
      'feels_like': 8.0,
      'temp_min': 9.0,
      'temp_max': 12.0,
      'pressure': 1015,
      'humidity': 85,
    },
    'wind': {'speed': 5.2, 'deg': 270},
    'sys': {
      'country': 'GB',
      'sunrise': 1672556400,
      'sunset': 1672596000,
    },
  };

  group('CurrentWeatherModel - fromJson', () {
    test('parses top-level fields correctly', () {
      final model = CurrentWeatherModel.fromJson(tWeatherJson);

      expect(model.id, 2643743);
      expect(model.name, 'London');
      expect(model.dt, 1672560000);
      expect(model.timezone, 0);
    });

    test('parses main temperature block correctly', () {
      final model = CurrentWeatherModel.fromJson(tWeatherJson);

      expect(model.main.temp, 10.5);
      expect(model.main.feelsLike, 8.0);
      expect(model.main.tempMin, 9.0);
      expect(model.main.tempMax, 12.0);
      expect(model.main.pressure, 1015);
      expect(model.main.humidity, 85);
    });

    test('parses weather condition array correctly', () {
      final model = CurrentWeatherModel.fromJson(tWeatherJson);

      expect(model.weather.length, 1);
      expect(model.weather.first.id, 804);
      expect(model.weather.first.main, 'Clouds');
      expect(model.weather.first.description, 'overcast clouds');
      expect(model.weather.first.icon, '04d');
    });

    test('parses wind correctly', () {
      final model = CurrentWeatherModel.fromJson(tWeatherJson);

      expect(model.wind.speed, 5.2);
      expect(model.wind.deg, 270);
    });

    test('parses sys (country, sunrise, sunset) correctly', () {
      final model = CurrentWeatherModel.fromJson(tWeatherJson);

      expect(model.sys.country, 'GB');
      expect(model.sys.sunrise, 1672556400);
      expect(model.sys.sunset, 1672596000);
    });

    test('handles empty weather array', () {
      final json = Map<String, dynamic>.from(tWeatherJson);
      json['weather'] = <dynamic>[];

      final model = CurrentWeatherModel.fromJson(json);

      expect(model.weather, isEmpty);
    });
  });

  group('CurrentWeatherModel - toJson', () {
    test('serializes and deserializes roundtrip correctly', () {
      final original = CurrentWeatherModel.fromJson(tWeatherJson);
      // Must go through jsonEncode→jsonDecode to convert nested Freezed
      // objects back into plain Map<String, dynamic> before fromJson.
      final json = jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final roundtripped = CurrentWeatherModel.fromJson(json);

      expect(roundtripped.name, original.name);
      expect(roundtripped.main.temp, original.main.temp);
      expect(roundtripped.wind.speed, original.wind.speed);
    });
  });

  group('CurrentWeatherModel - Freezed equality', () {
    test('two models with same data are equal', () {
      final m1 = CurrentWeatherModel.fromJson(tWeatherJson);
      final m2 = CurrentWeatherModel.fromJson(tWeatherJson);

      expect(m1, equals(m2));
    });

    test('copyWith creates different model', () {
      final original = CurrentWeatherModel.fromJson(tWeatherJson);
      final copy = original.copyWith(name: 'Manchester');

      expect(copy.name, 'Manchester');
      expect(original.name, 'London');
    });
  });
}
