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
  @override
  FutureOr<ForecastEntity?> build() {
    // We could automatically fetch forecast here if we wanted,
    // but typically we wait for weatherProvider to succeed,
    // or we fetch them concurrently.
    // For now, we start with null.
    return null;
  }

  Future<void> fetchForecast(String city) async {
    state = const AsyncValue.loading();
    try {
      final getForecast = ref.read(getForecastUseCaseProvider);
      final lang = ref.read(localeProvider).languageCode;
      final forecast = await getForecast.execute(city: city, lang: lang);
      state = AsyncValue.data(forecast);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchForecastByCoord(double lat, double lon, {String? cityNameOverride}) async {
    state = const AsyncValue.loading();
    try {
      final getForecast = ref.read(getForecastByCoordUseCaseProvider);
      final lang = ref.read(localeProvider).languageCode;
      var forecast = await getForecast.execute(lat: lat, lon: lon, lang: lang);
      
      if (cityNameOverride != null && cityNameOverride.isNotEmpty) {
        forecast = forecast.copyWith(cityName: cityNameOverride);
      }
      
      state = AsyncValue.data(forecast);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
