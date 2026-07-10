// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForecastEntity {

 String get cityName; List<ForecastItemEntity> get items;
/// Create a copy of ForecastEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastEntityCopyWith<ForecastEntity> get copyWith => _$ForecastEntityCopyWithImpl<ForecastEntity>(this as ForecastEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastEntity&&(identical(other.cityName, cityName) || other.cityName == cityName)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,cityName,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ForecastEntity(cityName: $cityName, items: $items)';
}


}

/// @nodoc
abstract mixin class $ForecastEntityCopyWith<$Res>  {
  factory $ForecastEntityCopyWith(ForecastEntity value, $Res Function(ForecastEntity) _then) = _$ForecastEntityCopyWithImpl;
@useResult
$Res call({
 String cityName, List<ForecastItemEntity> items
});




}
/// @nodoc
class _$ForecastEntityCopyWithImpl<$Res>
    implements $ForecastEntityCopyWith<$Res> {
  _$ForecastEntityCopyWithImpl(this._self, this._then);

  final ForecastEntity _self;
  final $Res Function(ForecastEntity) _then;

/// Create a copy of ForecastEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cityName = null,Object? items = null,}) {
  return _then(_self.copyWith(
cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ForecastItemEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastEntity].
extension ForecastEntityPatterns on ForecastEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastEntity value)  $default,){
final _that = this;
switch (_that) {
case _ForecastEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cityName,  List<ForecastItemEntity> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastEntity() when $default != null:
return $default(_that.cityName,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cityName,  List<ForecastItemEntity> items)  $default,) {final _that = this;
switch (_that) {
case _ForecastEntity():
return $default(_that.cityName,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cityName,  List<ForecastItemEntity> items)?  $default,) {final _that = this;
switch (_that) {
case _ForecastEntity() when $default != null:
return $default(_that.cityName,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ForecastEntity implements ForecastEntity {
  const _ForecastEntity({required this.cityName, required final  List<ForecastItemEntity> items}): _items = items;
  

@override final  String cityName;
 final  List<ForecastItemEntity> _items;
@override List<ForecastItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ForecastEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastEntityCopyWith<_ForecastEntity> get copyWith => __$ForecastEntityCopyWithImpl<_ForecastEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastEntity&&(identical(other.cityName, cityName) || other.cityName == cityName)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,cityName,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ForecastEntity(cityName: $cityName, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ForecastEntityCopyWith<$Res> implements $ForecastEntityCopyWith<$Res> {
  factory _$ForecastEntityCopyWith(_ForecastEntity value, $Res Function(_ForecastEntity) _then) = __$ForecastEntityCopyWithImpl;
@override @useResult
$Res call({
 String cityName, List<ForecastItemEntity> items
});




}
/// @nodoc
class __$ForecastEntityCopyWithImpl<$Res>
    implements _$ForecastEntityCopyWith<$Res> {
  __$ForecastEntityCopyWithImpl(this._self, this._then);

  final _ForecastEntity _self;
  final $Res Function(_ForecastEntity) _then;

/// Create a copy of ForecastEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cityName = null,Object? items = null,}) {
  return _then(_ForecastEntity(
cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ForecastItemEntity>,
  ));
}


}

/// @nodoc
mixin _$ForecastItemEntity {

 DateTime get dateTime; double get temperature; double get feelsLike; double get minTemp; double get maxTemp; String get condition; String get iconCode; double get windSpeed; int get humidity; double get pop;
/// Create a copy of ForecastItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastItemEntityCopyWith<ForecastItemEntity> get copyWith => _$ForecastItemEntityCopyWithImpl<ForecastItemEntity>(this as ForecastItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastItemEntity&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.minTemp, minTemp) || other.minTemp == minTemp)&&(identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.pop, pop) || other.pop == pop));
}


@override
int get hashCode => Object.hash(runtimeType,dateTime,temperature,feelsLike,minTemp,maxTemp,condition,iconCode,windSpeed,humidity,pop);

@override
String toString() {
  return 'ForecastItemEntity(dateTime: $dateTime, temperature: $temperature, feelsLike: $feelsLike, minTemp: $minTemp, maxTemp: $maxTemp, condition: $condition, iconCode: $iconCode, windSpeed: $windSpeed, humidity: $humidity, pop: $pop)';
}


}

/// @nodoc
abstract mixin class $ForecastItemEntityCopyWith<$Res>  {
  factory $ForecastItemEntityCopyWith(ForecastItemEntity value, $Res Function(ForecastItemEntity) _then) = _$ForecastItemEntityCopyWithImpl;
@useResult
$Res call({
 DateTime dateTime, double temperature, double feelsLike, double minTemp, double maxTemp, String condition, String iconCode, double windSpeed, int humidity, double pop
});




}
/// @nodoc
class _$ForecastItemEntityCopyWithImpl<$Res>
    implements $ForecastItemEntityCopyWith<$Res> {
  _$ForecastItemEntityCopyWithImpl(this._self, this._then);

  final ForecastItemEntity _self;
  final $Res Function(ForecastItemEntity) _then;

/// Create a copy of ForecastItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateTime = null,Object? temperature = null,Object? feelsLike = null,Object? minTemp = null,Object? maxTemp = null,Object? condition = null,Object? iconCode = null,Object? windSpeed = null,Object? humidity = null,Object? pop = null,}) {
  return _then(_self.copyWith(
dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,minTemp: null == minTemp ? _self.minTemp : minTemp // ignore: cast_nullable_to_non_nullable
as double,maxTemp: null == maxTemp ? _self.maxTemp : maxTemp // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastItemEntity].
extension ForecastItemEntityPatterns on ForecastItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _ForecastItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime dateTime,  double temperature,  double feelsLike,  double minTemp,  double maxTemp,  String condition,  String iconCode,  double windSpeed,  int humidity,  double pop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastItemEntity() when $default != null:
return $default(_that.dateTime,_that.temperature,_that.feelsLike,_that.minTemp,_that.maxTemp,_that.condition,_that.iconCode,_that.windSpeed,_that.humidity,_that.pop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime dateTime,  double temperature,  double feelsLike,  double minTemp,  double maxTemp,  String condition,  String iconCode,  double windSpeed,  int humidity,  double pop)  $default,) {final _that = this;
switch (_that) {
case _ForecastItemEntity():
return $default(_that.dateTime,_that.temperature,_that.feelsLike,_that.minTemp,_that.maxTemp,_that.condition,_that.iconCode,_that.windSpeed,_that.humidity,_that.pop);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime dateTime,  double temperature,  double feelsLike,  double minTemp,  double maxTemp,  String condition,  String iconCode,  double windSpeed,  int humidity,  double pop)?  $default,) {final _that = this;
switch (_that) {
case _ForecastItemEntity() when $default != null:
return $default(_that.dateTime,_that.temperature,_that.feelsLike,_that.minTemp,_that.maxTemp,_that.condition,_that.iconCode,_that.windSpeed,_that.humidity,_that.pop);case _:
  return null;

}
}

}

/// @nodoc


class _ForecastItemEntity implements ForecastItemEntity {
  const _ForecastItemEntity({required this.dateTime, required this.temperature, required this.feelsLike, required this.minTemp, required this.maxTemp, required this.condition, required this.iconCode, required this.windSpeed, required this.humidity, required this.pop});
  

@override final  DateTime dateTime;
@override final  double temperature;
@override final  double feelsLike;
@override final  double minTemp;
@override final  double maxTemp;
@override final  String condition;
@override final  String iconCode;
@override final  double windSpeed;
@override final  int humidity;
@override final  double pop;

/// Create a copy of ForecastItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastItemEntityCopyWith<_ForecastItemEntity> get copyWith => __$ForecastItemEntityCopyWithImpl<_ForecastItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastItemEntity&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.minTemp, minTemp) || other.minTemp == minTemp)&&(identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.iconCode, iconCode) || other.iconCode == iconCode)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.pop, pop) || other.pop == pop));
}


@override
int get hashCode => Object.hash(runtimeType,dateTime,temperature,feelsLike,minTemp,maxTemp,condition,iconCode,windSpeed,humidity,pop);

@override
String toString() {
  return 'ForecastItemEntity(dateTime: $dateTime, temperature: $temperature, feelsLike: $feelsLike, minTemp: $minTemp, maxTemp: $maxTemp, condition: $condition, iconCode: $iconCode, windSpeed: $windSpeed, humidity: $humidity, pop: $pop)';
}


}

/// @nodoc
abstract mixin class _$ForecastItemEntityCopyWith<$Res> implements $ForecastItemEntityCopyWith<$Res> {
  factory _$ForecastItemEntityCopyWith(_ForecastItemEntity value, $Res Function(_ForecastItemEntity) _then) = __$ForecastItemEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime dateTime, double temperature, double feelsLike, double minTemp, double maxTemp, String condition, String iconCode, double windSpeed, int humidity, double pop
});




}
/// @nodoc
class __$ForecastItemEntityCopyWithImpl<$Res>
    implements _$ForecastItemEntityCopyWith<$Res> {
  __$ForecastItemEntityCopyWithImpl(this._self, this._then);

  final _ForecastItemEntity _self;
  final $Res Function(_ForecastItemEntity) _then;

/// Create a copy of ForecastItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateTime = null,Object? temperature = null,Object? feelsLike = null,Object? minTemp = null,Object? maxTemp = null,Object? condition = null,Object? iconCode = null,Object? windSpeed = null,Object? humidity = null,Object? pop = null,}) {
  return _then(_ForecastItemEntity(
dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,minTemp: null == minTemp ? _self.minTemp : minTemp // ignore: cast_nullable_to_non_nullable
as double,maxTemp: null == maxTemp ? _self.maxTemp : maxTemp // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,iconCode: null == iconCode ? _self.iconCode : iconCode // ignore: cast_nullable_to_non_nullable
as String,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
