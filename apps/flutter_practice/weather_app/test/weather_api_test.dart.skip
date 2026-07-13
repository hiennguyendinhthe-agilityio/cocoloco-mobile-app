// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/network/dio_client.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource_impl.dart';
import 'package:weather_app/features/weather/data/sources/geocoding_api.dart';
import 'package:weather_app/features/weather/data/sources/weather_api.dart';

void main() {
  test('Weather Data Layer Integration Test', () async {
    print('--- START TEST WEATHER DATA LAYER ---');

    final dio = DioClient.create();
    dio.interceptors.clear();

    final weatherApi = WeatherApi(dio);
    final geocodingApi = GeocodingApi(dio);
    final dataSource = WeatherRemoteDatasourceImpl(weatherApi, geocodingApi);

    print('\nCalling API for Da Nang...');
    final weather = await dataSource.getCurrentWeather('Da Nang', lang: 'vi');
    print('✅ JSON parsed successfully with Freezed CurrentWeatherModel');
    print('✅ API key is working');
    print(
      '   => [${weather.name}, ${weather.sys.country}] Temperature: ${weather.main.temp}°C — ${weather.weather.first.description}',
    );
    expect(weather.name, isNotEmpty);

    print('\nCalling API for Ha Noi...');
    final locations = await dataSource.searchLocation('Ha Noi');
    print('✅ JSON parsed successfully with Freezed LocationModel');
    for (final loc in locations) {
      print(
        '   => Found: ${loc.name}, lat: ${loc.lat}, lon: ${loc.lon}, country: ${loc.country}',
      );
    }
    expect(locations, isNotEmpty);
  });
}
