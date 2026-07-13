import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';


void main() {
  const tForecastJson = {
    'list': [
      {
        'dt': 1672560000,
        'main': {
          'temp': 25.0,
          'feels_like': 26.0,
          'temp_min': 23.0,
          'temp_max': 27.0,
          'pressure': 1012,
          'humidity': 80,
        },
        'weather': [
          {
            'id': 800,
            'main': 'Clear',
            'description': 'clear sky',
            'icon': '01d',
          }
        ],
        'wind': {'speed': 4.0, 'deg': 90},
        'dt_txt': '2023-01-01 08:00:00',
        'pop': 0.2,
      }
    ],
    'city': {
      'id': 2643743,
      'name': 'London',
      'country': 'GB',
      'timezone': 0,
    },
  };

  group('ForecastModel - fromJson', () {
    test('parses city data correctly', () {
      final model = ForecastModel.fromJson(tForecastJson);

      expect(model.city.name, 'London');
      expect(model.city.country, 'GB');
      expect(model.city.id, 2643743);
      expect(model.city.timezone, 0);
    });

    test('parses forecast list correctly', () {
      final model = ForecastModel.fromJson(tForecastJson);

      expect(model.list.length, 1);
    });

    test('parses ForecastItem fields correctly', () {
      final model = ForecastModel.fromJson(tForecastJson);
      final item = model.list.first;

      expect(item.dt, 1672560000);
      expect(item.dtTxt, '2023-01-01 08:00:00');
      expect(item.pop, 0.2);
    });

    test('parses ForecastMainModel correctly', () {
      final item = ForecastModel.fromJson(tForecastJson).list.first;

      expect(item.main.temp, 25.0);
      expect(item.main.feelsLike, 26.0);
      expect(item.main.tempMin, 23.0);
      expect(item.main.tempMax, 27.0);
      expect(item.main.humidity, 80);
      expect(item.main.pressure, 1012);
    });

    test('parses ForecastWeatherDesc correctly', () {
      final item = ForecastModel.fromJson(tForecastJson).list.first;

      expect(item.weather.length, 1);
      expect(item.weather.first.description, 'clear sky');
      expect(item.weather.first.icon, '01d');
    });

    test('parses wind correctly', () {
      final item = ForecastModel.fromJson(tForecastJson).list.first;

      expect(item.wind.speed, 4.0);
      expect(item.wind.deg, 90);
    });

    test('pop defaults to 0.0 when missing', () {
      final jsonNoPop = Map<String, dynamic>.from(tForecastJson);
      final listNoPop = [
        {
          'dt': 1672560000,
          'main': {
            'temp': 25.0,
            'feels_like': 26.0,
            'temp_min': 23.0,
            'temp_max': 27.0,
            'pressure': 1012,
            'humidity': 80,
          },
          'weather': [
            {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01d'}
          ],
          'wind': {'speed': 4.0, 'deg': 90},
          'dt_txt': '2023-01-01 08:00:00',
          // no 'pop' key
        }
      ];
      jsonNoPop['list'] = listNoPop;

      final model = ForecastModel.fromJson(jsonNoPop);
      expect(model.list.first.pop, 0.0);
    });

    test('handles empty list', () {
      final emptyJson = {
        'list': <dynamic>[],
        'city': {
          'id': 1,
          'name': 'Empty',
          'country': 'EC',
          'timezone': 0,
        },
      };

      final model = ForecastModel.fromJson(emptyJson);
      expect(model.list, isEmpty);
    });
  });

  group('ForecastModel - toJson roundtrip', () {
    test('roundtrip preserves all data', () {
      final original = ForecastModel.fromJson(tForecastJson);
      // Must go via JSON string to convert Freezed objects → plain Maps
      final json = jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final restored = ForecastModel.fromJson(json);

      expect(restored.city.name, original.city.name);
      expect(restored.list.length, original.list.length);
      expect(restored.list.first.main.temp, original.list.first.main.temp);
    });
  });

  group('ForecastModel - Freezed equality', () {
    test('two identical models are equal', () {
      final m1 = ForecastModel.fromJson(tForecastJson);
      final m2 = ForecastModel.fromJson(tForecastJson);

      expect(m1, equals(m2));
    });
  });
}
