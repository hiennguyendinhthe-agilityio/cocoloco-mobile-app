import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_stats_card.dart';

import '../../../../test_utils.dart';
import '../../../../fixtures/weather.stub.dart';

void main() {
  group('WeatherStatsCard Widget Tests:', () {
    testWidgets('renders all stats correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        TestUtils.wrapWithApp(
          WeatherStatsCard(
            weather: WeatherStub.london,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(WeatherStatsCard));

      // Assert visual elements exist
      expect(find.byIcon(Icons.thermostat_rounded), findsOneWidget);
      expect(find.byIcon(Icons.water_drop_rounded), findsOneWidget);
      expect(find.byIcon(Icons.air_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);

      // Verify L10n strings
      expect(find.text(context.l10n.feelsLike), findsOneWidget);
      expect(find.text(context.l10n.humidity), findsOneWidget);
      expect(find.text(context.l10n.wind), findsOneWidget);
      expect(find.text(context.l10n.low), findsOneWidget);
      expect(find.text(context.l10n.high), findsOneWidget);

      // Verify values
      expect(find.text('${WeatherStub.london.feelsLike.toStringAsFixed(0)}°'), findsOneWidget);
      expect(find.text('${WeatherStub.london.humidity}%'), findsOneWidget);
      expect(find.text('${WeatherStub.london.windSpeed.toStringAsFixed(0)}m/s'), findsOneWidget);
      expect(find.text('${WeatherStub.london.minTemp.toStringAsFixed(0)}°'), findsOneWidget);
      expect(find.text('${WeatherStub.london.maxTemp.toStringAsFixed(0)}°'), findsOneWidget);
    });
  });
}
