// Data model — 5-Day / 3-Hour Forecast.
//
// Mirrors the OpenWeatherMap `/data/2.5/forecast` response.
// Freezed + JsonSerializable: immutable, copyWith, ==, fromJson/toJson.
//
// Nested models co-located:
//   - [ForecastItem]        — each 3-hour slot in list[]
//   - [ForecastMainModel]   — temp data per slot
//   - [ForecastWeatherDesc] — condition description per slot
//   - [ForecastCityModel]   — city metadata

import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_model.freezed.dart';
part 'forecast_model.g.dart';

// ── Top-level model ────────────────────────────────────────────────────────

@freezed
abstract class ForecastModel with _$ForecastModel {
  const factory ForecastModel({
    /// List of forecast items (up to 40, every 3h over 5 days)
    required List<ForecastItem> list,

    /// Target city metadata
    required ForecastCityModel city,
  }) = _ForecastModel;

  factory ForecastModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastModelFromJson(json);
}

// ── Nested: forecast slot ──────────────────────────────────────────────────

@freezed
abstract class ForecastItem with _$ForecastItem {
  const factory ForecastItem({
    /// Unix UTC timestamp for this slot
    required int dt,

    /// Temperature data
    required ForecastMainModel main,

    /// Weather conditions (normally 1 item)
    required List<ForecastWeatherDesc> weather,

    /// Wind
    required ForecastWindModel wind,

    /// ISO datetime string, e.g. "2024-07-04 12:00:00"
    @JsonKey(name: 'dt_txt') required String dtTxt,

    /// Probability of precipitation
    @Default(0.0) double pop,
  }) = _ForecastItem;

  factory ForecastItem.fromJson(Map<String, dynamic> json) =>
      _$ForecastItemFromJson(json);
}

// ── Nested: temp per slot ─────────────────────────────────────────────────

@freezed
abstract class ForecastMainModel with _$ForecastMainModel {
  const factory ForecastMainModel({
    required double temp,
    @JsonKey(name: 'feels_like') required double feelsLike,
    @JsonKey(name: 'temp_min') required double tempMin,
    @JsonKey(name: 'temp_max') required double tempMax,
    required int pressure,
    required int humidity,
  }) = _ForecastMainModel;

  factory ForecastMainModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastMainModelFromJson(json);
}

// ── Nested: condition description per slot ────────────────────────────────

@freezed
abstract class ForecastWeatherDesc with _$ForecastWeatherDesc {
  const factory ForecastWeatherDesc({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _ForecastWeatherDesc;

  factory ForecastWeatherDesc.fromJson(Map<String, dynamic> json) =>
      _$ForecastWeatherDescFromJson(json);
}

// ── Nested: wind per slot ─────────────────────────────────────────────────

@freezed
abstract class ForecastWindModel with _$ForecastWindModel {
  const factory ForecastWindModel({required double speed, required int deg}) =
      _ForecastWindModel;

  factory ForecastWindModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastWindModelFromJson(json);
}

// ── Nested: city ──────────────────────────────────────────────────────────

@freezed
abstract class ForecastCityModel with _$ForecastCityModel {
  const factory ForecastCityModel({
    required int id,
    required String name,
    required String country,

    /// Timezone offset in seconds from UTC
    required int timezone,
  }) = _ForecastCityModel;

  factory ForecastCityModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastCityModelFromJson(json);
}
