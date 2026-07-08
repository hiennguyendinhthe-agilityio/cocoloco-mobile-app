// Data model — Geocoding / Location.
//
// Mirrors the OpenWeatherMap `/geo/1.0/direct` response.
// The API returns a JSON array → Retrofit deserializes as List<LocationModel>.
// Freezed + JsonSerializable.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
abstract class LocationModel with _$LocationModel {
  const factory LocationModel({
    /// City name in the local language (or English fallback)
    required String name,

    /// Latitude
    required double lat,

    /// Longitude
    required double lon,

    /// ISO 3166-1 alpha-2 country code, e.g. "VN"
    required String country,

    /// State / province (may be null for some locations)
    String? state,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}

extension LocationModelX on LocationModel {
  LocationEntity toEntity() {
    return LocationEntity(
      name: name,
      lat: lat,
      lon: lon,
      country: country,
      state: state,
    );
  }
}
