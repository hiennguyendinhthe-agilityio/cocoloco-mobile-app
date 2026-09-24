import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/location_service_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/search_idle_view.dart';

import '../../../../../service.mocks.dart';
import '../../../../../test_utils.dart';

class FakePosition extends Fake implements Position {}

class FakeRecentSearchesNotifier extends RecentSearchesNotifier {
  final List<LocationEntity> initialSearches;
  FakeRecentSearchesNotifier([this.initialSearches = const []]);

  @override
  FutureOr<List<LocationEntity>> build() => initialSearches;

  @override
  Future<void> addRecentSearch(LocationEntity location) async {}

  @override
  Future<void> removeRecentSearch(LocationEntity location) async {}

  @override
  Future<void> clearRecentSearches() async {}
}

void main() {
  late MockWeatherNotifier mockWeatherNotifier;
  late MockForecastNotifier mockForecastNotifier;
  late MockLocationService mockLocationService;

  setUpAll(() {
    registerFallbackValue(FakePosition());
  });

  setUp(() {
    mockLocationService = MockLocationService();
    mockWeatherNotifier = MockWeatherNotifier();
    mockForecastNotifier = MockForecastNotifier();

    when(
      () => mockWeatherNotifier.fetchWeatherByCoord(
        any(),
        any(),
        cityNameOverride: any(named: 'cityNameOverride'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockForecastNotifier.fetchForecastByCoord(
        any(),
        any(),
        cityNameOverride: any(named: 'cityNameOverride'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockWeatherNotifier.fetchWeather(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockForecastNotifier.fetchForecast(any()),
    ).thenAnswer((_) async {});
  });

  group('SearchIdleView Widget Tests:', () {
    testWidgets('renders recent searches and popular cities correctly', (
      tester,
    ) async {
      final recentSearches = [
        LocationEntity(name: 'Paris', country: 'FR', lat: 48.8566, lon: 2.3522),
      ];

      final container = TestUtils.createContainer(
        overrides: [
          recentSearchesProvider.overrideWith(
            () => FakeRecentSearchesNotifier(recentSearches),
          ),
          weatherProvider.overrideWith(() => mockWeatherNotifier),
          forecastProvider.overrideWith(() => mockForecastNotifier),
        ],
      );

      bool closed = false;

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          SearchIdleView(onClose: () => closed = true),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SearchIdleView));

      // Assert labels
      expect(find.text(context.l10n.currentLocation), findsWidgets);
      expect(find.text(context.l10n.recentSearches), findsOneWidget);
      expect(find.text(context.l10n.popularCities), findsOneWidget);

      // Assert Paris is in recent searches
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('FR'), findsOneWidget);

      // Assert default popular cities
      expect(find.text(context.l10n.tokyo), findsOneWidget);
      expect(find.text(context.l10n.london), findsOneWidget);

      // Act: Tap Paris
      await tester.tap(find.text('Paris'));
      await tester.pumpAndSettle();

      // Provider should trigger close
      expect(closed, true);
    });

    testWidgets('handles current location tap successfully', (tester) async {
      when(() => mockLocationService.getCurrentPosition()).thenAnswer(
        (_) async => Position(
          longitude: 105.8,
          latitude: 21.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        ),
      );
      when(
        () => mockLocationService.getCityNameFromPosition(any()),
      ).thenAnswer((_) async => 'Hanoi');

      final container = TestUtils.createContainer(
        overrides: [
          locationServiceProvider.overrideWithValue(mockLocationService),
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
          SearchIdleView(onClose: () => closed = true),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      // Tap current location card
      final context = tester.element(find.byType(SearchIdleView));
      await tester.tap(find.text(context.l10n.currentLocation).last);

      // Wait for async locating
      await tester.pumpAndSettle();

      expect(closed, true);
      verify(() => mockLocationService.getCurrentPosition()).called(1);
      verify(
        () => mockLocationService.getCityNameFromPosition(any()),
      ).called(1);
    });
  });
}
