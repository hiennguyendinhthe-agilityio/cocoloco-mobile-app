import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_main_info.dart';

import '../../../../fixtures/weather.stub.dart';
import '../../../../test_utils.dart';

void main() {
  group('WeatherMainInfo Widget Tests:', () {
    testWidgets('renders weather info correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(WeatherMainInfo(weather: WeatherStub.london)),
      );
      await tester.pumpAndSettle();

      // Assert visual elements exist
      expect(
        find.text('${WeatherStub.london.temperature.toStringAsFixed(0)}°'),
        findsOneWidget,
      );
      expect(find.text('Clouds'), findsOneWidget); // capitalized condition

      // Since the time is dynamic (StreamBuilder), we just verify it exists by checking for a Text widget
      // that is not the temperature or condition
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, 3);
    });
  });
}
