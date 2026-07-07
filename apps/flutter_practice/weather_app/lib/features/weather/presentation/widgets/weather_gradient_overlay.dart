import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

class WeatherGradientOverlay extends StatelessWidget {
  final WeatherEntity? weather;

  const WeatherGradientOverlay({super.key, required this.weather});

  List<Color> _getGradientOverlayColors(WeatherEntity? w) {
    final defaultColors = [
      Colors.black.withAlpha(100),
      Colors.transparent,
      Colors.transparent,
      Colors.white.withAlpha(200),
    ];

    if (w == null) return defaultColors;

    final now = w.localTime;
    final sunrise = w.sunriseTime;
    final sunset = w.sunsetTime;

    final dawnStart = sunrise.subtract(const Duration(minutes: 45));
    final dawnEnd = sunrise.add(const Duration(minutes: 15));
    final duskStart = sunset.subtract(const Duration(minutes: 45));
    final duskEnd = sunset.add(const Duration(minutes: 15));

    if (now.isAfter(dawnStart) && now.isBefore(dawnEnd)) {
      return [
        Colors.deepOrange.withAlpha(80),
        Colors.transparent,
        Colors.transparent,
        Colors.orangeAccent.withAlpha(150),
      ];
    } else if (now.isAfter(duskStart) && now.isBefore(duskEnd)) {
      return [
        Colors.indigo.withAlpha(100),
        Colors.deepOrange.withAlpha(50),
        Colors.transparent,
        Colors.orange.withAlpha(180),
      ];
    } else if (now.isAfter(dawnEnd) && now.isBefore(duskStart)) {
      return defaultColors;
    } else {
      return [
        Colors.black.withAlpha(150),
        Colors.black.withAlpha(50),
        Colors.black.withAlpha(50),
        Colors.black.withAlpha(220),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.35, 0.7, 1.0],
          colors: _getGradientOverlayColors(weather),
        ),
      ),
    );
  }
}
