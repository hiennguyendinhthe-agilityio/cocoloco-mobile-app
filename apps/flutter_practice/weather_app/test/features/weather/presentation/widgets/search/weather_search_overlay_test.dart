import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/location_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/search_active_view.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/search_idle_view.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/weather_search_overlay.dart';

import '../../../../../test_utils.dart';

class FakeRecentSearchesNotifier extends RecentSearchesNotifier {
  @override
  FutureOr<List<LocationEntity>> build() => [];
}

void main() {
  group('WeatherSearchOverlay Widget Tests:', () {
    testWidgets('renders idle view when query is empty', (tester) async {
      final container = TestUtils.createContainer(
        overrides: [
          searchQueryProvider.overrideWith((ref) => ''),
          recentSearchesProvider.overrideWith(
            () => FakeRecentSearchesNotifier(),
          ),
        ],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          WeatherSearchOverlay(onCancel: () {}),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      // Expect to find SearchIdleView, not SearchActiveView
      expect(find.byType(SearchIdleView), findsOneWidget);
      expect(find.byType(SearchActiveView), findsNothing);
    });

    testWidgets('renders active view when query is not empty', (tester) async {
      final container = TestUtils.createContainer(
        overrides: [
          searchQueryProvider.overrideWith((ref) => 'London'),
          recentSearchesProvider.overrideWith(
            () => FakeRecentSearchesNotifier(),
          ),
        ],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          WeatherSearchOverlay(onCancel: () {}),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      // Expect to find SearchActiveView, not SearchIdleView
      expect(find.byType(SearchActiveView), findsOneWidget);
      expect(find.byType(SearchIdleView), findsNothing);
    });
  });
}
