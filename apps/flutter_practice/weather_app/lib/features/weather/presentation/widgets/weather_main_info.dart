import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class WeatherMainInfo extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherMainInfo({super.key, required this.weather});

  String _formatDate(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _toTitleCase(String s) => s
      .split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 48),
      child: ClipRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                  '${weather.temperature.toStringAsFixed(0)}°',
                  style: TextStyle(
                    color: context.glass.textPrimary,
                    fontSize: 100,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                    shadows: const [
                      Shadow(blurRadius: 20, color: Colors.black26),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 700.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  duration: 700.ms,
                  curve: Curves.easeOutCubic,
                ),
            Text(
              _toTitleCase(weather.condition),
              style: TextStyle(
                color: context.glass.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                shadows: const [Shadow(blurRadius: 8, color: Colors.black38)],
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 2),
            Text(
              _formatDate(weather.lastUpdated),
              style: TextStyle(
                color: context.glass.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
