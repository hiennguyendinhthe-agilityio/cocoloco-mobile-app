import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/presentation/widgets/daily_forecast_detail_sheet.dart';
import 'package:weather_app/l10n/app_localizations.dart';

// Helper to build forecast items for a given date
List<ForecastItemEntity> _makeItems(DateTime date, {int count = 3}) {
  return List.generate(
    count,
    (i) => ForecastItemEntity(
      dateTime: date.add(Duration(hours: i * 3)),
      temperature: 25.0 + i,
      feelsLike: 24.0 + i,
      minTemp: 22.0,
      maxTemp: 28.0,
      condition: 'clear sky',
      iconCode: '01d',
      windSpeed: 3.0,
      humidity: 70,
      pop: 0.1 * i,
    ),
  );
}

Widget wrapWithApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('vi')],
    home: Scaffold(body: child),
  );
}

void main() {
  final today = DateTime(2024, 7, 15, 12, 0);
  final tomorrow = DateTime(2024, 7, 16, 12, 0);

  final tForecast = ForecastEntity(
    cityName: 'London',
    items: [
      ..._makeItems(today),
      ..._makeItems(tomorrow),
    ],
  );

  group('DailyForecastDetailSheet - Rendering', () {
    testWidgets('renders weather conditions title', (tester) async {
      await tester.pumpWidget(wrapWithApp(
        DailyForecastDetailSheet(
          forecast: tForecast,
          initialSelectedDate: today,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Weather Conditions'), findsOneWidget);
    });

    testWidgets('renders close button', (tester) async {
      await tester.pumpWidget(wrapWithApp(
        DailyForecastDetailSheet(
          forecast: tForecast,
          initialSelectedDate: today,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows segmented control with Actual and Feels Like options', (tester) async {
      await tester.pumpWidget(wrapWithApp(
        DailyForecastDetailSheet(
          forecast: tForecast,
          initialSelectedDate: today,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Actual'), findsOneWidget);
      expect(find.text('Feels like'), findsOneWidget);
    });

    testWidgets('shows precipitation section', (tester) async {
      await tester.pumpWidget(wrapWithApp(
        DailyForecastDetailSheet(
          forecast: tForecast,
          initialSelectedDate: today,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Probability of precipitation'), findsOneWidget);
    });

    testWidgets('renders date selector with correct number of unique days', (tester) async {
      await tester.pumpWidget(wrapWithApp(
        DailyForecastDetailSheet(
          forecast: tForecast,
          initialSelectedDate: today,
        ),
      ));
      await tester.pumpAndSettle();

      // 2 unique days: today and tomorrow - show day number
      expect(find.text('15'), findsWidgets);
      expect(find.text('16'), findsWidgets);
    });
  });

  group('DailyForecastDetailSheet - Interactions', () {
    testWidgets('tapping another date switches selected date', (tester) async {
      await tester.pumpWidget(wrapWithApp(
        DailyForecastDetailSheet(
          forecast: tForecast,
          initialSelectedDate: today,
        ),
      ));
      await tester.pumpAndSettle();

      // Tap on '16' (tomorrow's date)
      final day16 = find.text('16');
      expect(day16, findsWidgets);
      await tester.tap(day16.first);
      await tester.pumpAndSettle();

      // After tapping, widget rebuilds without error
      expect(find.text('Weather Conditions'), findsOneWidget);
    });

    testWidgets('tapping Feels Like segment switches chart label', (tester) async {
      // Use a taller screen to accommodate the scrollable bottom sheet
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithApp(
        DailyForecastDetailSheet(
          forecast: tForecast,
          initialSelectedDate: today,
        ),
      ));
      await tester.pumpAndSettle();

      // Default shows "Actual temperature." description
      expect(find.text('Actual temperature.'), findsOneWidget);

      // Scroll to make the segmented control visible then tap
      final feelsLikeFinder = find.text('Feels like');
      await tester.ensureVisible(feelsLikeFinder);
      await tester.tap(feelsLikeFinder);
      await tester.pumpAndSettle();

      // Now shows "Feels like temperature." description
      expect(find.text('Feels like temperature.'), findsOneWidget);
    });
  });

  group('DailyForecastDetailSheet - Edge Cases', () {
    testWidgets('returns SizedBox if no data for selected date', (tester) async {
      // forecast with items only for tomorrow, but initialSelectedDate is today
      final emptyForecast = ForecastEntity(
        cityName: 'Test',
        items: _makeItems(tomorrow),
      );

      await tester.pumpWidget(wrapWithApp(
        DailyForecastDetailSheet(
          forecast: emptyForecast,
          initialSelectedDate: today, // no items for today
        ),
      ));
      await tester.pump();

      // Widget renders without crash, but shows SizedBox (nothing meaningful)
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
