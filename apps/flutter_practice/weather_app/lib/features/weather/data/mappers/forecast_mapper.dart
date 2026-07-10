import 'package:weather_app/features/weather/data/models/forecast_model.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';

abstract final class ForecastMapper {
  ForecastMapper._();

  static ForecastEntity toEntity(ForecastModel model) {
    // Calculate precise local times by shifting UTC time by the timezone offset
    DateTime getLocalTime(int unixSeconds) {
      final utcTime = DateTime.fromMillisecondsSinceEpoch(
        unixSeconds * 1000,
        isUtc: true,
      );
      return utcTime.add(Duration(seconds: model.city.timezone));
    }

    final items = model.list.map((item) {
      final weatherDesc = item.weather.isNotEmpty
          ? item.weather.first.description
          : 'Unknown';
      final iconCode = item.weather.isNotEmpty
          ? item.weather.first.icon
          : '01d';

      return ForecastItemEntity(
        dateTime: getLocalTime(item.dt),
        temperature: item.main.temp,
        feelsLike: item.main.feelsLike,
        minTemp: item.main.tempMin,
        maxTemp: item.main.tempMax,
        condition: weatherDesc,
        iconCode: iconCode,
        windSpeed: item.wind.speed,
        humidity: item.main.humidity,
        pop: item.pop,
      );
    }).toList();

    return ForecastEntity(
      cityName: model.city.name,
      items: items,
    );
  }
}
