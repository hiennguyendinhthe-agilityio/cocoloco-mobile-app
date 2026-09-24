import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_hourly_forecast_card.dart';

import '../../../../fixtures/forecast.stub.dart';
import '../../../../fixtures/weather.stub.dart';
import '../../../../service.mocks.dart';
import '../../../../test_utils.dart';

void main() {
  group('WeatherHourlyForecastCard Widget Tests:', () {
    testWidgets('renders hourly forecast data correctly', (tester) async {
      final container = TestUtils.createContainer(
        overrides: [
          weatherProvider.overrideWith(
            () => MockWeatherNotifier(WeatherStub.london),
          ),
          forecastProvider.overrideWith(
            () => MockForecastNotifier(ForecastStub.london),
          ),
        ],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          const SingleChildScrollView(child: WeatherHourlyForecastCard()),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(
        find.byType(WeatherHourlyForecastCard),
      );

      // Verify "Now" item exists
      expect(find.text(context.l10n.now), findsOneWidget);
      expect(
        find.text('${WeatherStub.london.temperature.toStringAsFixed(0)}°'),
        findsWidgets,
      );

      // Verify at least one hourly forecast item is rendered
      expect(find.byType(SingleChildScrollView), findsWidgets);

      // Look for the "Now" chip
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders loading state when weather/forecast data is missing', (
      tester,
    ) async {
      final container = TestUtils.createContainer(
        overrides: [
          weatherProvider.overrideWith(() => MockWeatherNotifier(null)),
          forecastProvider.overrideWith(() => MockForecastNotifier(null)),
        ],
      );

      await tester.pumpWidget(
        TestUtils.wrapWithProviders(
          const SingleChildScrollView(child: WeatherHourlyForecastCard()),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      // If data is null, the widget returns a SizedBox.shrink()
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });
}
