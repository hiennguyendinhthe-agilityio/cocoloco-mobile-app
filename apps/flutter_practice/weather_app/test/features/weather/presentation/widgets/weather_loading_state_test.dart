import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_loading_state.dart';

import '../../../../test_utils.dart';

void main() {
  group('WeatherLoadingState Widget Tests:', () {
    testWidgets('renders correctly', (tester) async {
      // For flutter_test, we need to handle repeating animations carefully
      // flutter_animate provides Animate.restartOnHotReload but doesn't easily stop repeats in tests.
      // So we test the raw widget without the animation wrapper, or we let the tester finish by stopping animations.

      // We will set pumpWidget, then use tester.pump(duration) to clear it.
      await tester.pumpWidget(
        TestUtils.wrapWithApp(const WeatherLoadingState()),
      );

      expect(find.byType(WeatherLoadingState), findsOneWidget);
      expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);

      // Cleanup: replace the widget tree with empty container to dispose the animation.
      // Then pump and wait enough time for the animation controller to completely dispose.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 2));
    });
  });
}
