import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/screens/home_screen.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_header_delegate.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_initial_state.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_loading_state.dart';

import '../../../../firebase_mock.dart';
import '../../../../service.mocks.dart';
import '../../../../test_utils.dart';

void main() {
  setUpAll(() {
    setupFirebaseAuthMocks();
  });

  group('HomeScreen Widget Tests:', () {
    testWidgets('renders WeatherInitialState when weather data is null', (
      tester,
    ) async {
      final container = TestUtils.createContainer(
        overrides: [
          weatherProvider.overrideWith(() => MockWeatherNotifier(null)),
          forecastProvider.overrideWith(() => MockForecastNotifier(null)),
          recentSearchesProvider.overrideWith(
            () => MockRecentSearchesNotifier([]),
          ),
        ],
      );

      await tester.runAsync(() async {
        await tester.pumpWidget(
          TestUtils.wrapWithProviders(const HomeScreen(), container: container),
        );
        await tester.pump();
      });

      expect(find.byType(WeatherInitialState), findsOneWidget);
    });

    testWidgets('renders WeatherLoadingState when weather data is loading', (
      tester,
    ) async {
      final container = TestUtils.createContainer(
        overrides: [
          weatherProvider.overrideWith(() {
            return FakeLoadingWeatherNotifier();
          }),
          forecastProvider.overrideWith(() => MockForecastNotifier(null)),
          recentSearchesProvider.overrideWith(
            () => MockRecentSearchesNotifier([]),
          ),
        ],
      );

      await tester.runAsync(() async {
        await tester.pumpWidget(
          TestUtils.wrapWithProviders(const HomeScreen(), container: container),
        );
        await tester.pump();
      });

      expect(find.byType(WeatherLoadingState), findsOneWidget);
    });

    testWidgets('renders weather layout when weather data is available', (
      tester,
    ) async {
      final mockWeather = WeatherEntity(
        cityName: 'Tokyo',
        countryCode: 'JP',
        temperature: 20,
        feelsLike: 19,
        minTemp: 18,
        maxTemp: 22,
        condition: 'Clear',
        iconCode: '01d',
        humidity: 50,
        windSpeed: 5,
        lastUpdated: DateTime.now(),
        localTime: DateTime.now(),
        sunriseTime: DateTime.now().subtract(const Duration(hours: 6)),
        sunsetTime: DateTime.now().add(const Duration(hours: 6)),
      );

      final container = TestUtils.createContainer(
        overrides: [
          weatherProvider.overrideWith(() => MockWeatherNotifier(mockWeather)),
          forecastProvider.overrideWith(() => MockForecastNotifier(null)),
          recentSearchesProvider.overrideWith(
            () => MockRecentSearchesNotifier([]),
          ),
        ],
      );

      await tester.runAsync(() async {
        await tester.pumpWidget(
          TestUtils.wrapWithProviders(const HomeScreen(), container: container),
        );
        await tester.pump();
      });

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(
        find.byType(WeatherHeaderDelegate),
        findsNothing,
      ); // It's a delegate, not a widget
      expect(find.byType(SliverPersistentHeader), findsOneWidget);
    });
  });
}

class FakeLoadingWeatherNotifier extends AsyncNotifier<WeatherEntity?>
    implements WeatherNotifier {
  @override
  FutureOr<WeatherEntity?> build() async {
    return Completer<WeatherEntity?>().future;
  }

  @override
  Future<void> fetchWeather(
    String cityName, {
    bool forceRefresh = false,
  }) async {}

  @override
  Future<void> fetchWeatherByCoord(
    double lat,
    double lon, {
    String? cityNameOverride,
    bool forceRefresh = false,
  }) async {}
}

class FakeErrorWeatherNotifier extends AsyncNotifier<WeatherEntity?>
    implements WeatherNotifier {
  @override
  FutureOr<WeatherEntity?> build() {
    // Instead of throwing an exception which crashes the test runner,
    // we return a Completer that completes with an error!
    Future.microtask(() {
      // Must not throw an unhandled exception to the Zone.
      // Riverpod actually catches Future.error automatically.
    });
    return Future.error('API Error');
  }

  @override
  Future<void> fetchWeather(
    String cityName, {
    bool forceRefresh = false,
  }) async {}

  @override
  Future<void> fetchWeatherByCoord(
    double lat,
    double lon, {
    String? cityNameOverride,
    bool forceRefresh = false,
  }) async {}
}
