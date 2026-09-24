import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/core/services/analytics_service.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/city_list_item.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/search_active_view.dart';

import '../../../../../service.mocks.dart';
import '../../../../../test_utils.dart';
import 'search_idle_view_test.dart';

void main() {
  late MockWeatherNotifier mockWeatherNotifier;
  late MockForecastNotifier mockForecastNotifier;

  setUpAll(() {
    AnalyticsService.instance = MockAnalyticsService();
    when(
      () => AnalyticsService.instance.logSearchCity(any()),
    ).thenAnswer((_) async {});
  });

  setUp(() {
    mockWeatherNotifier = MockWeatherNotifier();
    mockForecastNotifier = MockForecastNotifier();

    when(
      () => mockWeatherNotifier.fetchWeather(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockForecastNotifier.fetchForecast(any()),
    ).thenAnswer((_) async {});
  });

  group('SearchActiveView Widget Tests:', () {
    testWidgets('renders loading state correctly', (tester) async {
      final completer = Completer<List<LocationEntity>>();
      final container = TestUtils.createContainer(
        overrides: [
          searchResultsProvider.overrideWith((ref) => completer.future),
        ],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          SearchActiveView(onClose: () {}),
          container: container,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state correctly', (tester) async {
      final container = TestUtils.createContainer(
        overrides: [
          searchResultsProvider.overrideWith(
            (ref) => throw Exception('Network Error'),
          ),
        ],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          SearchActiveView(onClose: () {}),
          container: container,
        ),
      );

      expect(find.textContaining('Network Error'), findsOneWidget);
    });

    testWidgets('renders no results message when list is empty', (
      tester,
    ) async {
      final container = TestUtils.createContainer(
        overrides: [searchResultsProvider.overrideWith((ref) => [])],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          SearchActiveView(onClose: () {}),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SearchActiveView));
      expect(find.text(context.l10n.noResultsFound), findsOneWidget);
    });

    testWidgets('renders search results and handles tap', (tester) async {
      final searchResults = [
        LocationEntity(name: 'Paris', country: 'FR', lat: 48.85, lon: 2.35),
        LocationEntity(name: 'Tokyo', country: 'JP', lat: 35.68, lon: 139.69),
      ];

      final container = TestUtils.createContainer(
        overrides: [
          searchResultsProvider.overrideWith((ref) => searchResults),
          recentSearchesProvider.overrideWith(
            () => FakeRecentSearchesNotifier([]),
          ),
          weatherProvider.overrideWith(() => mockWeatherNotifier),
          forecastProvider.overrideWith(() => mockForecastNotifier),
        ],
      );

      bool closed = false;

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          SearchActiveView(onClose: () => closed = true),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CityListItem), findsNWidgets(2));
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('Tokyo'), findsOneWidget);

      // Act: Tap Paris
      await tester.tap(find.text('Paris'));
      await tester.pumpAndSettle();

      expect(closed, true);
      verify(() => mockWeatherNotifier.fetchWeather('Paris')).called(1);
      verify(() => mockForecastNotifier.fetchForecast('Paris')).called(1);
    });
  });
}
