import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_entity.freezed.dart';
part 'location_entity.g.dart'; // Used for SharedPreferences JSON serialization

@freezed
abstract class LocationEntity with _$LocationEntity {
  const factory LocationEntity({
    required String name,
    required double lat,
    required double lon,
    required String country,
    String? state,
  }) = _LocationEntity;

  factory LocationEntity.fromJson(Map<String, dynamic> json) =>
      _$LocationEntityFromJson(json);
}
