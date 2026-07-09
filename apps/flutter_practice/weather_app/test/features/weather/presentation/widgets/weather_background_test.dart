import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_background.dart';
import 'package:weather_app/features/weather/presentation/widgets/fog_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/rain_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/shooting_star_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/snow_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/sun_rays_overlay.dart';
import 'package:weather_app/features/weather/presentation/widgets/wind_overlay.dart';

void main() {
  WeatherEntity createWeather({
    required String iconCode,
    double temperature = 20,
    double windSpeed = 0,
  }) {
    return WeatherEntity(
      cityName: 'Test City',
      countryCode: 'TC',
      temperature: temperature,
      feelsLike: temperature,
      minTemp: temperature - 2,
      maxTemp: temperature + 2,
      condition: 'Test Condition',
      iconCode: iconCode,
      humidity: 50,
      windSpeed: windSpeed,
      lastUpdated: DateTime.now(),
      localTime: DateTime.now(),
      sunriseTime: DateTime.now(),
      sunsetTime: DateTime.now(),
    );
  }

  Widget createWidgetUnderTest(WeatherEntity? weather) {
    return MaterialApp(
      home: Scaffold(
        body: WeatherBackground(weather: weather),
      ),
    );
  }

  group('WeatherBackground Mapping', () {
    testWidgets('null weather defaults to sunny', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(null));
      expect(find.byType(Image), findsOneWidget);
      // We can't strictly inspect Image.asset string easily without a custom key, 
      // but we can verify no overlays are present.
      expect(find.byType(RainOverlay), findsNothing);
      expect(find.byType(SnowOverlay), findsNothing);
    });

    testWidgets('Night icon (endsWith n) mounts ShootingStarOverlay', (tester) async {
      final weather = createWeather(iconCode: '01n');
      await tester.pumpWidget(createWidgetUnderTest(weather));
      expect(find.byType(ShootingStarOverlay), findsOneWidget);
      
      // Fast forward time to flush the initial Future.delayed timer 
      // without advancing the animation to the end (which would spawn another timer).
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('Hot day (01d, temp >= 30) mounts SunRaysOverlay', (tester) async {
      final weather = createWeather(iconCode: '01d', temperature: 35);
      await tester.pumpWidget(createWidgetUnderTest(weather));
      expect(find.byType(SunRaysOverlay), findsOneWidget);
    });

    testWidgets('Rainy days mount RainOverlay', (tester) async {
      final weather = createWeather(iconCode: '10d');
      await tester.pumpWidget(createWidgetUnderTest(weather));
      expect(find.byType(RainOverlay), findsOneWidget);
    });

    testWidgets('Snowy days (13d) mount SnowOverlay', (tester) async {
      final weather = createWeather(iconCode: '13d');
      await tester.pumpWidget(createWidgetUnderTest(weather));
      expect(find.byType(SnowOverlay), findsOneWidget);
    });

    testWidgets('Foggy days (50d) mount FogOverlay', (tester) async {
      final weather = createWeather(iconCode: '50d');
      await tester.pumpWidget(createWidgetUnderTest(weather));
      expect(find.byType(FogOverlay), findsOneWidget);
    });

    testWidgets('Windy days (windSpeed > 6) mount WindOverlay', (tester) async {
      final weather = createWeather(iconCode: '02d', windSpeed: 10.0);
      await tester.pumpWidget(createWidgetUnderTest(weather));
      expect(find.byType(WindOverlay), findsOneWidget);
    });

    testWidgets('Cloudy/Overcast (03d, 04d) uses bg_fog.png without FogOverlay', (tester) async {
      final weather = createWeather(iconCode: '04d');
      await tester.pumpWidget(createWidgetUnderTest(weather));
      // Overcast uses the gray/gloomy image but shouldn't obscure vision with thick fog
      expect(find.byType(FogOverlay), findsNothing);
      expect(find.byType(RainOverlay), findsNothing);
      expect(find.byType(SnowOverlay), findsNothing);
    });
  });
}
