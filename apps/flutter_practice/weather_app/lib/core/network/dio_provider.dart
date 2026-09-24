// Network Providers.
//
// Riverpod providers for network clients.
//
// Rules:
//   - Keep instances alive via Provider (default, not AutoDispose), since
//     network clients can be safely shared across the app's lifetime.
//   - Isolate Dio configuration to DioClient.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/network/dio_client.dart';
import 'package:weather_app/features/weather/data/datasources/remote/geocoding_api.dart';
import 'package:weather_app/features/weather/data/datasources/remote/weather_api.dart';

/// Provides a singleton instance of [Dio].
final dioProvider = Provider<Dio>((ref) {
  return DioClient.create();
});

/// Provides [WeatherApi] client.
final weatherApiProvider = Provider<WeatherApi>((ref) {
  final dio = ref.watch(dioProvider);
  return WeatherApi(dio);
});

/// Provides [GeocodingApi] client.
final geocodingApiProvider = Provider<GeocodingApi>((ref) {
  final dio = ref.watch(dioProvider);
  return GeocodingApi(dio);
});
