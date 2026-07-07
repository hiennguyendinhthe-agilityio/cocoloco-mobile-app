import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class WeatherLoadingState extends StatelessWidget {
  const WeatherLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.wb_sunny_rounded,
        size: 64,
        color: context.glass.iconSecondary,
      ).animate(onPlay: (c) => c.repeat()).rotate(duration: 2000.ms),
    );
  }
}
