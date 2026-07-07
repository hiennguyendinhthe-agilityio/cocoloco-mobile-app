import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/widgets/glass_card.dart';

class WeatherStatsCard extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherStatsCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.thermostat_rounded,
            label: context.l10n.feelsLike,
            value: '${weather.feelsLike.toStringAsFixed(0)}°',
          ),
          _StatItem(
            icon: Icons.water_drop_rounded,
            label: context.l10n.humidity,
            value: '${weather.humidity}%',
          ),
          _StatItem(
            icon: Icons.air_rounded,
            label: context.l10n.wind,
            value: '${weather.windSpeed.toStringAsFixed(0)}m/s',
          ),
          _StatItem(
            icon: Icons.arrow_downward_rounded,
            label: context.l10n.low,
            value: '${weather.minTemp.toStringAsFixed(0)}°',
          ),
          _StatItem(
            icon: Icons.arrow_upward_rounded,
            label: context.l10n.high,
            value: '${weather.maxTemp.toStringAsFixed(0)}°',
          ),
        ],
      ),
    ).animate().slideY(
      begin: 1,
      end: 0,
      duration: 600.ms,
      delay: 200.ms,
      curve: Curves.easeOutCubic,
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF3B82F6), size: 24), // Vibrant blue
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
