import 'package:weather_app/features/weather/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';

abstract interface class WeatherLocalDatasource {
  Future<CurrentWeatherModel?> getCachedCurrentWeather(String key, {bool ignoreExpiration = false});
  Future<void> cacheCurrentWeather(String key, CurrentWeatherModel model);

  Future<ForecastModel?> getCachedForecast(String key, {bool ignoreExpiration = false});
  Future<void> cacheForecast(String key, ForecastModel model);
}
