// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationEntity {

 String get name; double get lat; double get lon; String get country; String? get state;
/// Create a copy of LocationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationEntityCopyWith<LocationEntity> get copyWith => _$LocationEntityCopyWithImpl<LocationEntity>(this as LocationEntity, _$identity);

  /// Serializes this LocationEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,lat,lon,country,state);

@override
String toString() {
  return 'LocationEntity(name: $name, lat: $lat, lon: $lon, country: $country, state: $state)';
}


}

/// @nodoc
abstract mixin class $LocationEntityCopyWith<$Res>  {
  factory $LocationEntityCopyWith(LocationEntity value, $Res Function(LocationEntity) _then) = _$LocationEntityCopyWithImpl;
@useResult
$Res call({
 String name, double lat, double lon, String country, String? state
});




}
/// @nodoc
class _$LocationEntityCopyWithImpl<$Res>
    implements $LocationEntityCopyWith<$Res> {
  _$LocationEntityCopyWithImpl(this._self, this._then);

  final LocationEntity _self;
  final $Res Function(LocationEntity) _then;

/// Create a copy of LocationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? lat = null,Object? lon = null,Object? country = null,Object? state = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationEntity].
extension LocationEntityPatterns on LocationEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationEntity value)  $default,){
final _that = this;
switch (_that) {
case _LocationEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LocationEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double lat,  double lon,  String country,  String? state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationEntity() when $default != null:
return $default(_that.name,_that.lat,_that.lon,_that.country,_that.state);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double lat,  double lon,  String country,  String? state)  $default,) {final _that = this;
switch (_that) {
case _LocationEntity():
return $default(_that.name,_that.lat,_that.lon,_that.country,_that.state);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double lat,  double lon,  String country,  String? state)?  $default,) {final _that = this;
switch (_that) {
case _LocationEntity() when $default != null:
return $default(_that.name,_that.lat,_that.lon,_that.country,_that.state);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationEntity implements LocationEntity {
  const _LocationEntity({required this.name, required this.lat, required this.lon, required this.country, this.state});
  factory _LocationEntity.fromJson(Map<String, dynamic> json) => _$LocationEntityFromJson(json);

@override final  String name;
@override final  double lat;
@override final  double lon;
@override final  String country;
@override final  String? state;

/// Create a copy of LocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationEntityCopyWith<_LocationEntity> get copyWith => __$LocationEntityCopyWithImpl<_LocationEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,lat,lon,country,state);

@override
String toString() {
  return 'LocationEntity(name: $name, lat: $lat, lon: $lon, country: $country, state: $state)';
}


}

/// @nodoc
abstract mixin class _$LocationEntityCopyWith<$Res> implements $LocationEntityCopyWith<$Res> {
  factory _$LocationEntityCopyWith(_LocationEntity value, $Res Function(_LocationEntity) _then) = __$LocationEntityCopyWithImpl;
@override @useResult
$Res call({
 String name, double lat, double lon, String country, String? state
});




}
/// @nodoc
class __$LocationEntityCopyWithImpl<$Res>
    implements _$LocationEntityCopyWith<$Res> {
  __$LocationEntityCopyWithImpl(this._self, this._then);

  final _LocationEntity _self;
  final $Res Function(_LocationEntity) _then;

/// Create a copy of LocationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? lat = null,Object? lon = null,Object? country = null,Object? state = freezed,}) {
  return _then(_LocationEntity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
