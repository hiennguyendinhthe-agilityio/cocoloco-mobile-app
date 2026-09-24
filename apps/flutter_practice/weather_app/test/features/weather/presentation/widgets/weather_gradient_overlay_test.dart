import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_gradient_overlay.dart';

import '../../../../fixtures/weather.stub.dart';
import '../../../../test_utils.dart';

void main() {
  group('WeatherGradientOverlay Widget Tests:', () {
    testWidgets('renders correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          WeatherGradientOverlay(weather: WeatherStub.london),
        ),
      );
      await tester.pumpAndSettle();

      // We mainly just want to verify it builds without throwing.
      // There are no text elements to assert.
      expect(find.byType(WeatherGradientOverlay), findsOneWidget);
    });

    testWidgets('renders with null weather', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(const WeatherGradientOverlay(weather: null)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WeatherGradientOverlay), findsOneWidget);
    });
  });
}
