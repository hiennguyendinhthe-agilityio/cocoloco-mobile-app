import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/localization/locale_provider.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_by_coord_usecase.dart';

final forecastProvider = AsyncNotifierProvider<ForecastNotifier, ForecastEntity?>(
  ForecastNotifier.new,
);

class ForecastNotifier extends AsyncNotifier<ForecastEntity?> {
  String? _lastSearchedCity;
  double? _lastLat;
  double? _lastLon;
  String? _lastCityNameOverride;

  @override
  FutureOr<ForecastEntity?> build() {
    ref.listen(localeProvider, (previous, next) {
      if (previous != null && previous.languageCode != next.languageCode) {
        _refetch();
      }
    });
    return null;
  }

  void _refetch({bool forceRefresh = false}) {
    if (_lastLat != null && _lastLon != null) {
      fetchForecastByCoord(_lastLat!, _lastLon!, cityNameOverride: _lastCityNameOverride, forceRefresh: forceRefresh);
    } else if (_lastSearchedCity != null) {
      fetchForecast(_lastSearchedCity!, forceRefresh: forceRefresh);
    }
  }

  Future<void> fetchForecast(String city, {bool forceRefresh = false}) async {
    _lastSearchedCity = city;
    _lastLat = null;
    _lastLon = null;
    _lastCityNameOverride = null;
    state = const AsyncValue.loading();
    try {
      final getForecast = ref.read(getForecastUseCaseProvider);
      final lang = ref.read(localeProvider).languageCode;
      final forecast = await getForecast.execute(city: city, lang: lang, forceRefresh: forceRefresh);
      state = AsyncValue.data(forecast);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchForecastByCoord(double lat, double lon, {String? cityNameOverride, bool forceRefresh = false}) async {
    _lastSearchedCity = null;
    _lastLat = lat;
    _lastLon = lon;
    _lastCityNameOverride = cityNameOverride;
    state = const AsyncValue.loading();
    try {
      final getForecast = ref.read(getForecastByCoordUseCaseProvider);
      final lang = ref.read(localeProvider).languageCode;
      var forecast = await getForecast.execute(lat: lat, lon: lon, lang: lang, forceRefresh: forceRefresh);
      
      if (cityNameOverride != null && cityNameOverride.isNotEmpty) {
        forecast = forecast.copyWith(cityName: cityNameOverride);
      }
      
      state = AsyncValue.data(forecast);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
