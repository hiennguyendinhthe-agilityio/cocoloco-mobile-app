import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_daily_forecast_card.dart';

import '../../../../fixtures/forecast.stub.dart';
import '../../../../service.mocks.dart';
import '../../../../test_utils.dart';

void main() {
  group('WeatherDailyForecastCard Widget Tests:', () {
    testWidgets('renders daily forecast data correctly', (tester) async {
      final container = TestUtils.createContainer(
        overrides: [
          forecastProvider.overrideWith(
            () => MockForecastNotifier(ForecastStub.london),
          ),
        ],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          const SingleChildScrollView(child: WeatherDailyForecastCard()),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);

      // Verify humidity icons or texts
      expect(find.byIcon(Icons.water_drop_rounded), findsWidgets);
    });

    testWidgets('renders nothing when forecast data is missing', (
      tester,
    ) async {
      final container = TestUtils.createContainer(
        overrides: [
          forecastProvider.overrideWith(() => MockForecastNotifier(null)),
        ],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          const SingleChildScrollView(child: WeatherDailyForecastCard()),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      // If data is null, the widget returns a SizedBox.shrink()
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(ListView), findsNothing);
    });
  });
}
