// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForecastModel {

/// List of forecast items (up to 40, every 3h over 5 days)
 List<ForecastItem> get list;/// Target city metadata
 ForecastCityModel get city;
/// Create a copy of ForecastModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastModelCopyWith<ForecastModel> get copyWith => _$ForecastModelCopyWithImpl<ForecastModel>(this as ForecastModel, _$identity);

  /// Serializes this ForecastModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastModel&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),city);

@override
String toString() {
  return 'ForecastModel(list: $list, city: $city)';
}


}

/// @nodoc
abstract mixin class $ForecastModelCopyWith<$Res>  {
  factory $ForecastModelCopyWith(ForecastModel value, $Res Function(ForecastModel) _then) = _$ForecastModelCopyWithImpl;
@useResult
$Res call({
 List<ForecastItem> list, ForecastCityModel city
});


$ForecastCityModelCopyWith<$Res> get city;

}
/// @nodoc
class _$ForecastModelCopyWithImpl<$Res>
    implements $ForecastModelCopyWith<$Res> {
  _$ForecastModelCopyWithImpl(this._self, this._then);

  final ForecastModel _self;
  final $Res Function(ForecastModel) _then;

/// Create a copy of ForecastModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? city = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<ForecastItem>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as ForecastCityModel,
  ));
}
/// Create a copy of ForecastModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForecastCityModelCopyWith<$Res> get city {
  
  return $ForecastCityModelCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForecastModel].
extension ForecastModelPatterns on ForecastModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastModel value)  $default,){
final _that = this;
switch (_that) {
case _ForecastModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ForecastItem> list,  ForecastCityModel city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastModel() when $default != null:
return $default(_that.list,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ForecastItem> list,  ForecastCityModel city)  $default,) {final _that = this;
switch (_that) {
case _ForecastModel():
return $default(_that.list,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ForecastItem> list,  ForecastCityModel city)?  $default,) {final _that = this;
switch (_that) {
case _ForecastModel() when $default != null:
return $default(_that.list,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastModel implements ForecastModel {
  const _ForecastModel({required final  List<ForecastItem> list, required this.city}): _list = list;
  factory _ForecastModel.fromJson(Map<String, dynamic> json) => _$ForecastModelFromJson(json);

/// List of forecast items (up to 40, every 3h over 5 days)
 final  List<ForecastItem> _list;
/// List of forecast items (up to 40, every 3h over 5 days)
@override List<ForecastItem> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

/// Target city metadata
@override final  ForecastCityModel city;

/// Create a copy of ForecastModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastModelCopyWith<_ForecastModel> get copyWith => __$ForecastModelCopyWithImpl<_ForecastModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastModel&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),city);

@override
String toString() {
  return 'ForecastModel(list: $list, city: $city)';
}


}

/// @nodoc
abstract mixin class _$ForecastModelCopyWith<$Res> implements $ForecastModelCopyWith<$Res> {
  factory _$ForecastModelCopyWith(_ForecastModel value, $Res Function(_ForecastModel) _then) = __$ForecastModelCopyWithImpl;
@override @useResult
$Res call({
 List<ForecastItem> list, ForecastCityModel city
});


@override $ForecastCityModelCopyWith<$Res> get city;

}
/// @nodoc
class __$ForecastModelCopyWithImpl<$Res>
    implements _$ForecastModelCopyWith<$Res> {
  __$ForecastModelCopyWithImpl(this._self, this._then);

  final _ForecastModel _self;
  final $Res Function(_ForecastModel) _then;

/// Create a copy of ForecastModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? city = null,}) {
  return _then(_ForecastModel(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<ForecastItem>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as ForecastCityModel,
  ));
}

/// Create a copy of ForecastModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForecastCityModelCopyWith<$Res> get city {
  
  return $ForecastCityModelCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// @nodoc
mixin _$ForecastItem {

/// Unix UTC timestamp for this slot
 int get dt;/// Temperature data
 ForecastMainModel get main;/// Weather conditions (normally 1 item)
 List<ForecastWeatherDesc> get weather;/// Wind
 ForecastWindModel get wind;/// ISO datetime string, e.g. "2024-07-04 12:00:00"
@JsonKey(name: 'dt_txt') String get dtTxt;/// Probability of precipitation
 double get pop;
/// Create a copy of ForecastItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastItemCopyWith<ForecastItem> get copyWith => _$ForecastItemCopyWithImpl<ForecastItem>(this as ForecastItem, _$identity);

  /// Serializes this ForecastItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastItem&&(identical(other.dt, dt) || other.dt == dt)&&(identical(other.main, main) || other.main == main)&&const DeepCollectionEquality().equals(other.weather, weather)&&(identical(other.wind, wind) || other.wind == wind)&&(identical(other.dtTxt, dtTxt) || other.dtTxt == dtTxt)&&(identical(other.pop, pop) || other.pop == pop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dt,main,const DeepCollectionEquality().hash(weather),wind,dtTxt,pop);

@override
String toString() {
  return 'ForecastItem(dt: $dt, main: $main, weather: $weather, wind: $wind, dtTxt: $dtTxt, pop: $pop)';
}


}

/// @nodoc
abstract mixin class $ForecastItemCopyWith<$Res>  {
  factory $ForecastItemCopyWith(ForecastItem value, $Res Function(ForecastItem) _then) = _$ForecastItemCopyWithImpl;
@useResult
$Res call({
 int dt, ForecastMainModel main, List<ForecastWeatherDesc> weather, ForecastWindModel wind,@JsonKey(name: 'dt_txt') String dtTxt, double pop
});


$ForecastMainModelCopyWith<$Res> get main;$ForecastWindModelCopyWith<$Res> get wind;

}
/// @nodoc
class _$ForecastItemCopyWithImpl<$Res>
    implements $ForecastItemCopyWith<$Res> {
  _$ForecastItemCopyWithImpl(this._self, this._then);

  final ForecastItem _self;
  final $Res Function(ForecastItem) _then;

/// Create a copy of ForecastItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dt = null,Object? main = null,Object? weather = null,Object? wind = null,Object? dtTxt = null,Object? pop = null,}) {
  return _then(_self.copyWith(
dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as ForecastMainModel,weather: null == weather ? _self.weather : weather // ignore: cast_nullable_to_non_nullable
as List<ForecastWeatherDesc>,wind: null == wind ? _self.wind : wind // ignore: cast_nullable_to_non_nullable
as ForecastWindModel,dtTxt: null == dtTxt ? _self.dtTxt : dtTxt // ignore: cast_nullable_to_non_nullable
as String,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of ForecastItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForecastMainModelCopyWith<$Res> get main {
  
  return $ForecastMainModelCopyWith<$Res>(_self.main, (value) {
    return _then(_self.copyWith(main: value));
  });
}/// Create a copy of ForecastItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForecastWindModelCopyWith<$Res> get wind {
  
  return $ForecastWindModelCopyWith<$Res>(_self.wind, (value) {
    return _then(_self.copyWith(wind: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForecastItem].
extension ForecastItemPatterns on ForecastItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastItem value)  $default,){
final _that = this;
switch (_that) {
case _ForecastItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastItem value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dt,  ForecastMainModel main,  List<ForecastWeatherDesc> weather,  ForecastWindModel wind, @JsonKey(name: 'dt_txt')  String dtTxt,  double pop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastItem() when $default != null:
return $default(_that.dt,_that.main,_that.weather,_that.wind,_that.dtTxt,_that.pop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dt,  ForecastMainModel main,  List<ForecastWeatherDesc> weather,  ForecastWindModel wind, @JsonKey(name: 'dt_txt')  String dtTxt,  double pop)  $default,) {final _that = this;
switch (_that) {
case _ForecastItem():
return $default(_that.dt,_that.main,_that.weather,_that.wind,_that.dtTxt,_that.pop);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dt,  ForecastMainModel main,  List<ForecastWeatherDesc> weather,  ForecastWindModel wind, @JsonKey(name: 'dt_txt')  String dtTxt,  double pop)?  $default,) {final _that = this;
switch (_that) {
case _ForecastItem() when $default != null:
return $default(_that.dt,_that.main,_that.weather,_that.wind,_that.dtTxt,_that.pop);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastItem implements ForecastItem {
  const _ForecastItem({required this.dt, required this.main, required final  List<ForecastWeatherDesc> weather, required this.wind, @JsonKey(name: 'dt_txt') required this.dtTxt, this.pop = 0.0}): _weather = weather;
  factory _ForecastItem.fromJson(Map<String, dynamic> json) => _$ForecastItemFromJson(json);

/// Unix UTC timestamp for this slot
@override final  int dt;
/// Temperature data
@override final  ForecastMainModel main;
/// Weather conditions (normally 1 item)
 final  List<ForecastWeatherDesc> _weather;
/// Weather conditions (normally 1 item)
@override List<ForecastWeatherDesc> get weather {
  if (_weather is EqualUnmodifiableListView) return _weather;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weather);
}

/// Wind
@override final  ForecastWindModel wind;
/// ISO datetime string, e.g. "2024-07-04 12:00:00"
@override@JsonKey(name: 'dt_txt') final  String dtTxt;
/// Probability of precipitation
@override@JsonKey() final  double pop;

/// Create a copy of ForecastItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastItemCopyWith<_ForecastItem> get copyWith => __$ForecastItemCopyWithImpl<_ForecastItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastItem&&(identical(other.dt, dt) || other.dt == dt)&&(identical(other.main, main) || other.main == main)&&const DeepCollectionEquality().equals(other._weather, _weather)&&(identical(other.wind, wind) || other.wind == wind)&&(identical(other.dtTxt, dtTxt) || other.dtTxt == dtTxt)&&(identical(other.pop, pop) || other.pop == pop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dt,main,const DeepCollectionEquality().hash(_weather),wind,dtTxt,pop);

@override
String toString() {
  return 'ForecastItem(dt: $dt, main: $main, weather: $weather, wind: $wind, dtTxt: $dtTxt, pop: $pop)';
}


}

/// @nodoc
abstract mixin class _$ForecastItemCopyWith<$Res> implements $ForecastItemCopyWith<$Res> {
  factory _$ForecastItemCopyWith(_ForecastItem value, $Res Function(_ForecastItem) _then) = __$ForecastItemCopyWithImpl;
@override @useResult
$Res call({
 int dt, ForecastMainModel main, List<ForecastWeatherDesc> weather, ForecastWindModel wind,@JsonKey(name: 'dt_txt') String dtTxt, double pop
});


@override $ForecastMainModelCopyWith<$Res> get main;@override $ForecastWindModelCopyWith<$Res> get wind;

}
/// @nodoc
class __$ForecastItemCopyWithImpl<$Res>
    implements _$ForecastItemCopyWith<$Res> {
  __$ForecastItemCopyWithImpl(this._self, this._then);

  final _ForecastItem _self;
  final $Res Function(_ForecastItem) _then;

/// Create a copy of ForecastItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dt = null,Object? main = null,Object? weather = null,Object? wind = null,Object? dtTxt = null,Object? pop = null,}) {
  return _then(_ForecastItem(
dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as ForecastMainModel,weather: null == weather ? _self._weather : weather // ignore: cast_nullable_to_non_nullable
as List<ForecastWeatherDesc>,wind: null == wind ? _self.wind : wind // ignore: cast_nullable_to_non_nullable
as ForecastWindModel,dtTxt: null == dtTxt ? _self.dtTxt : dtTxt // ignore: cast_nullable_to_non_nullable
as String,pop: null == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ForecastItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForecastMainModelCopyWith<$Res> get main {
  
  return $ForecastMainModelCopyWith<$Res>(_self.main, (value) {
    return _then(_self.copyWith(main: value));
  });
}/// Create a copy of ForecastItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForecastWindModelCopyWith<$Res> get wind {
  
  return $ForecastWindModelCopyWith<$Res>(_self.wind, (value) {
    return _then(_self.copyWith(wind: value));
  });
}
}


/// @nodoc
mixin _$ForecastMainModel {

 double get temp;@JsonKey(name: 'feels_like') double get feelsLike;@JsonKey(name: 'temp_min') double get tempMin;@JsonKey(name: 'temp_max') double get tempMax; int get pressure; int get humidity;
/// Create a copy of ForecastMainModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastMainModelCopyWith<ForecastMainModel> get copyWith => _$ForecastMainModelCopyWithImpl<ForecastMainModel>(this as ForecastMainModel, _$identity);

  /// Serializes this ForecastMainModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastMainModel&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.tempMin, tempMin) || other.tempMin == tempMin)&&(identical(other.tempMax, tempMax) || other.tempMax == tempMax)&&(identical(other.pressure, pressure) || other.pressure == pressure)&&(identical(other.humidity, humidity) || other.humidity == humidity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temp,feelsLike,tempMin,tempMax,pressure,humidity);

@override
String toString() {
  return 'ForecastMainModel(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, humidity: $humidity)';
}


}

/// @nodoc
abstract mixin class $ForecastMainModelCopyWith<$Res>  {
  factory $ForecastMainModelCopyWith(ForecastMainModel value, $Res Function(ForecastMainModel) _then) = _$ForecastMainModelCopyWithImpl;
@useResult
$Res call({
 double temp,@JsonKey(name: 'feels_like') double feelsLike,@JsonKey(name: 'temp_min') double tempMin,@JsonKey(name: 'temp_max') double tempMax, int pressure, int humidity
});




}
/// @nodoc
class _$ForecastMainModelCopyWithImpl<$Res>
    implements $ForecastMainModelCopyWith<$Res> {
  _$ForecastMainModelCopyWithImpl(this._self, this._then);

  final ForecastMainModel _self;
  final $Res Function(ForecastMainModel) _then;

/// Create a copy of ForecastMainModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temp = null,Object? feelsLike = null,Object? tempMin = null,Object? tempMax = null,Object? pressure = null,Object? humidity = null,}) {
  return _then(_self.copyWith(
temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,tempMin: null == tempMin ? _self.tempMin : tempMin // ignore: cast_nullable_to_non_nullable
as double,tempMax: null == tempMax ? _self.tempMax : tempMax // ignore: cast_nullable_to_non_nullable
as double,pressure: null == pressure ? _self.pressure : pressure // ignore: cast_nullable_to_non_nullable
as int,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastMainModel].
extension ForecastMainModelPatterns on ForecastMainModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastMainModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastMainModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastMainModel value)  $default,){
final _that = this;
switch (_that) {
case _ForecastMainModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastMainModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastMainModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temp, @JsonKey(name: 'feels_like')  double feelsLike, @JsonKey(name: 'temp_min')  double tempMin, @JsonKey(name: 'temp_max')  double tempMax,  int pressure,  int humidity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastMainModel() when $default != null:
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.humidity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temp, @JsonKey(name: 'feels_like')  double feelsLike, @JsonKey(name: 'temp_min')  double tempMin, @JsonKey(name: 'temp_max')  double tempMax,  int pressure,  int humidity)  $default,) {final _that = this;
switch (_that) {
case _ForecastMainModel():
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.humidity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temp, @JsonKey(name: 'feels_like')  double feelsLike, @JsonKey(name: 'temp_min')  double tempMin, @JsonKey(name: 'temp_max')  double tempMax,  int pressure,  int humidity)?  $default,) {final _that = this;
switch (_that) {
case _ForecastMainModel() when $default != null:
return $default(_that.temp,_that.feelsLike,_that.tempMin,_that.tempMax,_that.pressure,_that.humidity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastMainModel implements ForecastMainModel {
  const _ForecastMainModel({required this.temp, @JsonKey(name: 'feels_like') required this.feelsLike, @JsonKey(name: 'temp_min') required this.tempMin, @JsonKey(name: 'temp_max') required this.tempMax, required this.pressure, required this.humidity});
  factory _ForecastMainModel.fromJson(Map<String, dynamic> json) => _$ForecastMainModelFromJson(json);

@override final  double temp;
@override@JsonKey(name: 'feels_like') final  double feelsLike;
@override@JsonKey(name: 'temp_min') final  double tempMin;
@override@JsonKey(name: 'temp_max') final  double tempMax;
@override final  int pressure;
@override final  int humidity;

/// Create a copy of ForecastMainModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastMainModelCopyWith<_ForecastMainModel> get copyWith => __$ForecastMainModelCopyWithImpl<_ForecastMainModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastMainModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastMainModel&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.tempMin, tempMin) || other.tempMin == tempMin)&&(identical(other.tempMax, tempMax) || other.tempMax == tempMax)&&(identical(other.pressure, pressure) || other.pressure == pressure)&&(identical(other.humidity, humidity) || other.humidity == humidity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temp,feelsLike,tempMin,tempMax,pressure,humidity);

@override
String toString() {
  return 'ForecastMainModel(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, humidity: $humidity)';
}


}

/// @nodoc
abstract mixin class _$ForecastMainModelCopyWith<$Res> implements $ForecastMainModelCopyWith<$Res> {
  factory _$ForecastMainModelCopyWith(_ForecastMainModel value, $Res Function(_ForecastMainModel) _then) = __$ForecastMainModelCopyWithImpl;
@override @useResult
$Res call({
 double temp,@JsonKey(name: 'feels_like') double feelsLike,@JsonKey(name: 'temp_min') double tempMin,@JsonKey(name: 'temp_max') double tempMax, int pressure, int humidity
});




}
/// @nodoc
class __$ForecastMainModelCopyWithImpl<$Res>
    implements _$ForecastMainModelCopyWith<$Res> {
  __$ForecastMainModelCopyWithImpl(this._self, this._then);

  final _ForecastMainModel _self;
  final $Res Function(_ForecastMainModel) _then;

/// Create a copy of ForecastMainModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temp = null,Object? feelsLike = null,Object? tempMin = null,Object? tempMax = null,Object? pressure = null,Object? humidity = null,}) {
  return _then(_ForecastMainModel(
temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,tempMin: null == tempMin ? _self.tempMin : tempMin // ignore: cast_nullable_to_non_nullable
as double,tempMax: null == tempMax ? _self.tempMax : tempMax // ignore: cast_nullable_to_non_nullable
as double,pressure: null == pressure ? _self.pressure : pressure // ignore: cast_nullable_to_non_nullable
as int,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ForecastWeatherDesc {

 int get id; String get main; String get description; String get icon;
/// Create a copy of ForecastWeatherDesc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastWeatherDescCopyWith<ForecastWeatherDesc> get copyWith => _$ForecastWeatherDescCopyWithImpl<ForecastWeatherDesc>(this as ForecastWeatherDesc, _$identity);

  /// Serializes this ForecastWeatherDesc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastWeatherDesc&&(identical(other.id, id) || other.id == id)&&(identical(other.main, main) || other.main == main)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,main,description,icon);

@override
String toString() {
  return 'ForecastWeatherDesc(id: $id, main: $main, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $ForecastWeatherDescCopyWith<$Res>  {
  factory $ForecastWeatherDescCopyWith(ForecastWeatherDesc value, $Res Function(ForecastWeatherDesc) _then) = _$ForecastWeatherDescCopyWithImpl;
@useResult
$Res call({
 int id, String main, String description, String icon
});




}
/// @nodoc
class _$ForecastWeatherDescCopyWithImpl<$Res>
    implements $ForecastWeatherDescCopyWith<$Res> {
  _$ForecastWeatherDescCopyWithImpl(this._self, this._then);

  final ForecastWeatherDesc _self;
  final $Res Function(ForecastWeatherDesc) _then;

/// Create a copy of ForecastWeatherDesc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? main = null,Object? description = null,Object? icon = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastWeatherDesc].
extension ForecastWeatherDescPatterns on ForecastWeatherDesc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastWeatherDesc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastWeatherDesc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastWeatherDesc value)  $default,){
final _that = this;
switch (_that) {
case _ForecastWeatherDesc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastWeatherDesc value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastWeatherDesc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String main,  String description,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastWeatherDesc() when $default != null:
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String main,  String description,  String icon)  $default,) {final _that = this;
switch (_that) {
case _ForecastWeatherDesc():
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String main,  String description,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _ForecastWeatherDesc() when $default != null:
return $default(_that.id,_that.main,_that.description,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastWeatherDesc implements ForecastWeatherDesc {
  const _ForecastWeatherDesc({required this.id, required this.main, required this.description, required this.icon});
  factory _ForecastWeatherDesc.fromJson(Map<String, dynamic> json) => _$ForecastWeatherDescFromJson(json);

@override final  int id;
@override final  String main;
@override final  String description;
@override final  String icon;

/// Create a copy of ForecastWeatherDesc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastWeatherDescCopyWith<_ForecastWeatherDesc> get copyWith => __$ForecastWeatherDescCopyWithImpl<_ForecastWeatherDesc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastWeatherDescToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastWeatherDesc&&(identical(other.id, id) || other.id == id)&&(identical(other.main, main) || other.main == main)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,main,description,icon);

@override
String toString() {
  return 'ForecastWeatherDesc(id: $id, main: $main, description: $description, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$ForecastWeatherDescCopyWith<$Res> implements $ForecastWeatherDescCopyWith<$Res> {
  factory _$ForecastWeatherDescCopyWith(_ForecastWeatherDesc value, $Res Function(_ForecastWeatherDesc) _then) = __$ForecastWeatherDescCopyWithImpl;
@override @useResult
$Res call({
 int id, String main, String description, String icon
});




}
/// @nodoc
class __$ForecastWeatherDescCopyWithImpl<$Res>
    implements _$ForecastWeatherDescCopyWith<$Res> {
  __$ForecastWeatherDescCopyWithImpl(this._self, this._then);

  final _ForecastWeatherDesc _self;
  final $Res Function(_ForecastWeatherDesc) _then;

/// Create a copy of ForecastWeatherDesc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? main = null,Object? description = null,Object? icon = null,}) {
  return _then(_ForecastWeatherDesc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,main: null == main ? _self.main : main // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ForecastWindModel {

 double get speed; int get deg;
/// Create a copy of ForecastWindModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastWindModelCopyWith<ForecastWindModel> get copyWith => _$ForecastWindModelCopyWithImpl<ForecastWindModel>(this as ForecastWindModel, _$identity);

  /// Serializes this ForecastWindModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastWindModel&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.deg, deg) || other.deg == deg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speed,deg);

@override
String toString() {
  return 'ForecastWindModel(speed: $speed, deg: $deg)';
}


}

/// @nodoc
abstract mixin class $ForecastWindModelCopyWith<$Res>  {
  factory $ForecastWindModelCopyWith(ForecastWindModel value, $Res Function(ForecastWindModel) _then) = _$ForecastWindModelCopyWithImpl;
@useResult
$Res call({
 double speed, int deg
});




}
/// @nodoc
class _$ForecastWindModelCopyWithImpl<$Res>
    implements $ForecastWindModelCopyWith<$Res> {
  _$ForecastWindModelCopyWithImpl(this._self, this._then);

  final ForecastWindModel _self;
  final $Res Function(ForecastWindModel) _then;

/// Create a copy of ForecastWindModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? speed = null,Object? deg = null,}) {
  return _then(_self.copyWith(
speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,deg: null == deg ? _self.deg : deg // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastWindModel].
extension ForecastWindModelPatterns on ForecastWindModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastWindModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastWindModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastWindModel value)  $default,){
final _that = this;
switch (_that) {
case _ForecastWindModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastWindModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastWindModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double speed,  int deg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastWindModel() when $default != null:
return $default(_that.speed,_that.deg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double speed,  int deg)  $default,) {final _that = this;
switch (_that) {
case _ForecastWindModel():
return $default(_that.speed,_that.deg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double speed,  int deg)?  $default,) {final _that = this;
switch (_that) {
case _ForecastWindModel() when $default != null:
return $default(_that.speed,_that.deg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastWindModel implements ForecastWindModel {
  const _ForecastWindModel({required this.speed, required this.deg});
  factory _ForecastWindModel.fromJson(Map<String, dynamic> json) => _$ForecastWindModelFromJson(json);

@override final  double speed;
@override final  int deg;

/// Create a copy of ForecastWindModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastWindModelCopyWith<_ForecastWindModel> get copyWith => __$ForecastWindModelCopyWithImpl<_ForecastWindModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastWindModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastWindModel&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.deg, deg) || other.deg == deg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speed,deg);

@override
String toString() {
  return 'ForecastWindModel(speed: $speed, deg: $deg)';
}


}

/// @nodoc
abstract mixin class _$ForecastWindModelCopyWith<$Res> implements $ForecastWindModelCopyWith<$Res> {
  factory _$ForecastWindModelCopyWith(_ForecastWindModel value, $Res Function(_ForecastWindModel) _then) = __$ForecastWindModelCopyWithImpl;
@override @useResult
$Res call({
 double speed, int deg
});




}
/// @nodoc
class __$ForecastWindModelCopyWithImpl<$Res>
    implements _$ForecastWindModelCopyWith<$Res> {
  __$ForecastWindModelCopyWithImpl(this._self, this._then);

  final _ForecastWindModel _self;
  final $Res Function(_ForecastWindModel) _then;

/// Create a copy of ForecastWindModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speed = null,Object? deg = null,}) {
  return _then(_ForecastWindModel(
speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,deg: null == deg ? _self.deg : deg // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ForecastCityModel {

 int get id; String get name; String get country;/// Timezone offset in seconds from UTC
 int get timezone;
/// Create a copy of ForecastCityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastCityModelCopyWith<ForecastCityModel> get copyWith => _$ForecastCityModelCopyWithImpl<ForecastCityModel>(this as ForecastCityModel, _$identity);

  /// Serializes this ForecastCityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForecastCityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,country,timezone);

@override
String toString() {
  return 'ForecastCityModel(id: $id, name: $name, country: $country, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $ForecastCityModelCopyWith<$Res>  {
  factory $ForecastCityModelCopyWith(ForecastCityModel value, $Res Function(ForecastCityModel) _then) = _$ForecastCityModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String country, int timezone
});




}
/// @nodoc
class _$ForecastCityModelCopyWithImpl<$Res>
    implements $ForecastCityModelCopyWith<$Res> {
  _$ForecastCityModelCopyWithImpl(this._self, this._then);

  final ForecastCityModel _self;
  final $Res Function(ForecastCityModel) _then;

/// Create a copy of ForecastCityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? country = null,Object? timezone = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ForecastCityModel].
extension ForecastCityModelPatterns on ForecastCityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForecastCityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForecastCityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForecastCityModel value)  $default,){
final _that = this;
switch (_that) {
case _ForecastCityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForecastCityModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForecastCityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String country,  int timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForecastCityModel() when $default != null:
return $default(_that.id,_that.name,_that.country,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String country,  int timezone)  $default,) {final _that = this;
switch (_that) {
case _ForecastCityModel():
return $default(_that.id,_that.name,_that.country,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String country,  int timezone)?  $default,) {final _that = this;
switch (_that) {
case _ForecastCityModel() when $default != null:
return $default(_that.id,_that.name,_that.country,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForecastCityModel implements ForecastCityModel {
  const _ForecastCityModel({required this.id, required this.name, required this.country, required this.timezone});
  factory _ForecastCityModel.fromJson(Map<String, dynamic> json) => _$ForecastCityModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String country;
/// Timezone offset in seconds from UTC
@override final  int timezone;

/// Create a copy of ForecastCityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastCityModelCopyWith<_ForecastCityModel> get copyWith => __$ForecastCityModelCopyWithImpl<_ForecastCityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastCityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForecastCityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,country,timezone);

@override
String toString() {
  return 'ForecastCityModel(id: $id, name: $name, country: $country, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$ForecastCityModelCopyWith<$Res> implements $ForecastCityModelCopyWith<$Res> {
  factory _$ForecastCityModelCopyWith(_ForecastCityModel value, $Res Function(_ForecastCityModel) _then) = __$ForecastCityModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String country, int timezone
});




}
/// @nodoc
class __$ForecastCityModelCopyWithImpl<$Res>
    implements _$ForecastCityModelCopyWith<$Res> {
  __$ForecastCityModelCopyWithImpl(this._self, this._then);

  final _ForecastCityModel _self;
  final $Res Function(_ForecastCityModel) _then;

/// Create a copy of ForecastCityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? country = null,Object? timezone = null,}) {
  return _then(_ForecastCityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
