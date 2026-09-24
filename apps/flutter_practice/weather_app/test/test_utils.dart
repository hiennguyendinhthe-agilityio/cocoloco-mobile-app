import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/theme/app_theme.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

import 'fixtures/forecast.stub.dart';
import 'fixtures/weather.stub.dart';

abstract final class TestUtils {
  const TestUtils._();

  static ProviderContainer createContainer({
    List<Override> overrides = const [],
    ProviderContainer? parent,
  }) {
    final container = ProviderContainer(
      parent: parent,
      overrides: overrides,
    );
    addTearDown(container.dispose);
    return container;
  }

  static WeatherEntity createWeather({
    String cityName = 'London',
    String countryCode = 'GB',
    double temperature = 20.0,
    double feelsLike = 19.5,
    double minTemp = 18.0,
    double maxTemp = 22.0,
    String condition = 'Clouds',
    String iconCode = '04d',
    int humidity = 70,
    double windSpeed = 5.0,
    DateTime? lastUpdated,
    DateTime? localTime,
    DateTime? sunriseTime,
    DateTime? sunsetTime,
  }) {
    final now = DateTime(2024, 7, 15, 12, 0);
    return WeatherEntity(
      cityName: cityName,
      countryCode: countryCode,
      temperature: temperature,
      feelsLike: feelsLike,
      minTemp: minTemp,
      maxTemp: maxTemp,
      condition: condition,
      iconCode: iconCode,
      humidity: humidity,
      windSpeed: windSpeed,
      lastUpdated: lastUpdated ?? now,
      localTime: localTime ?? now,
      sunriseTime: sunriseTime ?? now,
      sunsetTime: sunsetTime ?? now,
    );
  }

  static ForecastEntity createForecast({
    String cityName = 'London',
    List<ForecastItemEntity>? items,
  }) {
    return ForecastEntity(
      cityName: cityName,
      items: items ?? ForecastStub.sampleItems,
    );
  }

  static Widget wrapWithProviders(
    Widget child, {
    required ProviderContainer container,
  }) {
    return UncontrolledProviderScope(
      container: container,
      child: wrapWithApp(child),
    );
  }

  static Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      home: Scaffold(body: child),
    );
  }

  static final kFixedDate = DateTime(2024, 7, 15, 12, 0);
  static WeatherEntity get kWeatherLondon => WeatherStub.london;
  static WeatherEntity get kWeatherHanoi => WeatherStub.hanoi;
  static ForecastEntity get kEmptyForecast => ForecastStub.empty;
}
