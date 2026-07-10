import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_entity.freezed.dart';

@freezed
abstract class ForecastEntity with _$ForecastEntity {
  const factory ForecastEntity({
    required String cityName,
    required List<ForecastItemEntity> items,
  }) = _ForecastEntity;
}

@freezed
abstract class ForecastItemEntity with _$ForecastItemEntity {
  const factory ForecastItemEntity({
    required DateTime dateTime,
    required double temperature,
    required double feelsLike,
    required double minTemp,
    required double maxTemp,
    required String condition,
    required String iconCode,
    required double windSpeed,
    required int humidity,
    required double pop, // Probability of precipitation (if available, otherwise 0)
  }) = _ForecastItemEntity;
}
