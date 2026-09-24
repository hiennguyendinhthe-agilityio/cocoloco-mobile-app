import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_header_delegate.dart';

import '../../../../test_utils.dart';
import '../../../../fixtures/weather.stub.dart';

void main() {
  group('WeatherHeaderDelegate Tests:', () {
    testWidgets('renders header content correctly at max extent', (tester) async {
      bool searchPressed = false;

      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: WeatherHeaderDelegate(
                  weather: WeatherStub.london,
                  expandedHeight: 300,
                  onSearchPressed: () => searchPressed = true,
                ),
              ),
              // Dummy content to allow scrolling
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('Item $index')),
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert: The city name and search icon should be visible
      expect(find.text(WeatherStub.london.cityName), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

      // Act
      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pumpAndSettle();

      // Assert
      expect(searchPressed, true);
    });

    testWidgets('shows blurred background when scrolled (min extent)', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: WeatherHeaderDelegate(
                  weather: WeatherStub.london,
                  expandedHeight: 300,
                  onSearchPressed: () {},
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('Item $index')),
                  childCount: 50,
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act: scroll up by 300 pixels to reach min extent
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Assert: Temperature indicator next to city name becomes visible when shrunk
      expect(find.text('${WeatherStub.london.temperature.toStringAsFixed(0)}°'), findsWidgets);
    });
  });
}
