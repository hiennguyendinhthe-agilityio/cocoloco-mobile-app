// State Management — Weather Provider.
//
// Rules:
//   - Uses [AsyncNotifier] (Riverpod 3 standard) to manage asynchronous state.
//   - State type is [WeatherEntity?]. Null means no city has been searched yet.
//   - Relies completely on [AsyncValue] for Loading / Error / Data states.
//   - Interacts ONLY with Domain UseCases ([GetCurrentWeatherUseCase]), never
//     Repositories or Data Sources directly.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/localization/locale_provider.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_by_coord_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_current_weather_usecase.dart';

class WeatherNotifier extends AsyncNotifier<WeatherEntity?> {
  String? _lastSearchedCity;
  double? _lastLat;
  double? _lastLon;
  String? _lastCityNameOverride;

  @override
  FutureOr<WeatherEntity?> build() {
    // Automatically refetch weather when language changes
    ref.listen(localeProvider, (previous, next) {
      if (previous != null && previous.languageCode != next.languageCode) {
        _refetch();
      }
    });
    return null;
  }

  void _refetch({bool forceRefresh = false}) {
    if (_lastLat != null && _lastLon != null) {
      fetchWeatherByCoord(_lastLat!, _lastLon!, cityNameOverride: _lastCityNameOverride, forceRefresh: forceRefresh);
    } else if (_lastSearchedCity != null) {
      fetchWeather(_lastSearchedCity!, forceRefresh: forceRefresh);
    }
  }

  Future<void> fetchWeather(String city, {bool forceRefresh = false}) async {
    _lastSearchedCity = city;
    _lastLat = null;
    _lastLon = null;
    _lastCityNameOverride = null;
    state = const AsyncValue.loading();

    final useCase = ref.read(getCurrentWeatherUseCaseProvider);
    final lang = ref.read(localeProvider).languageCode;

    state = await AsyncValue.guard(
      () => useCase.execute(city: city, lang: lang, forceRefresh: forceRefresh),
    );
  }

  Future<void> fetchWeatherByCoord(
    double lat,
    double lon, {
    String? cityNameOverride,
    bool forceRefresh = false,
  }) async {
    _lastSearchedCity = null;
    _lastLat = lat;
    _lastLon = lon;
    _lastCityNameOverride = cityNameOverride;
    state = const AsyncValue.loading();

    final useCase = ref.read(getCurrentWeatherByCoordUseCaseProvider);
    final lang = ref.read(localeProvider).languageCode;

    state = await AsyncValue.guard(() async {
      final entity = await useCase.execute(lat: lat, lon: lon, lang: lang, forceRefresh: forceRefresh);
      if (cityNameOverride != null && cityNameOverride.isNotEmpty) {
        return entity.copyWith(cityName: cityNameOverride);
      }
      return entity;
    });
  }
}

final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherEntity?>(
  WeatherNotifier.new,
);
