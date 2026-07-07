// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForecastModel _$ForecastModelFromJson(Map<String, dynamic> json) =>
    _ForecastModel(
      list: (json['list'] as List<dynamic>)
          .map((e) => ForecastItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: ForecastCityModel.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForecastModelToJson(_ForecastModel instance) =>
    <String, dynamic>{'list': instance.list, 'city': instance.city};

_ForecastItem _$ForecastItemFromJson(Map<String, dynamic> json) =>
    _ForecastItem(
      dt: (json['dt'] as num).toInt(),
      main: ForecastMainModel.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => ForecastWeatherDesc.fromJson(e as Map<String, dynamic>))
          .toList(),
      wind: ForecastWindModel.fromJson(json['wind'] as Map<String, dynamic>),
      dtTxt: json['dt_txt'] as String,
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ForecastItemToJson(_ForecastItem instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'main': instance.main,
      'weather': instance.weather,
      'wind': instance.wind,
      'dt_txt': instance.dtTxt,
      'pop': instance.pop,
    };

_ForecastMainModel _$ForecastMainModelFromJson(Map<String, dynamic> json) =>
    _ForecastMainModel(
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      pressure: (json['pressure'] as num).toInt(),
      humidity: (json['humidity'] as num).toInt(),
    );

Map<String, dynamic> _$ForecastMainModelToJson(_ForecastMainModel instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'temp_min': instance.tempMin,
      'temp_max': instance.tempMax,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
    };

_ForecastWeatherDesc _$ForecastWeatherDescFromJson(Map<String, dynamic> json) =>
    _ForecastWeatherDesc(
      id: (json['id'] as num).toInt(),
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$ForecastWeatherDescToJson(
  _ForecastWeatherDesc instance,
) => <String, dynamic>{
  'id': instance.id,
  'main': instance.main,
  'description': instance.description,
  'icon': instance.icon,
};

_ForecastWindModel _$ForecastWindModelFromJson(Map<String, dynamic> json) =>
    _ForecastWindModel(
      speed: (json['speed'] as num).toDouble(),
      deg: (json['deg'] as num).toInt(),
    );

Map<String, dynamic> _$ForecastWindModelToJson(_ForecastWindModel instance) =>
    <String, dynamic>{'speed': instance.speed, 'deg': instance.deg};

_ForecastCityModel _$ForecastCityModelFromJson(Map<String, dynamic> json) =>
    _ForecastCityModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      country: json['country'] as String,
      timezone: (json['timezone'] as num).toInt(),
    );

Map<String, dynamic> _$ForecastCityModelToJson(_ForecastCityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'timezone': instance.timezone,
    };
