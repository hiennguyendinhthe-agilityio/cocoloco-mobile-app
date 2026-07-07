import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/glass_card.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class _HourlyDisplayData {
  final String time;
  final String iconCode;
  final double temperature;
  final bool isNow;

  _HourlyDisplayData({
    required this.time,
    required this.iconCode,
    required this.temperature,
    this.isNow = false,
  });
}

class WeatherHourlyForecastCard extends ConsumerWidget {
  const WeatherHourlyForecastCard({super.key});

  List<_HourlyDisplayData> _generateHourlyData(
    WeatherEntity current,
    ForecastEntity forecast,
  ) {
    final List<_HourlyDisplayData> result = [];
    final now = current.localTime;

    // 1. Add "Now"
    result.add(
      _HourlyDisplayData(
        time: 'Now',
        iconCode: current.iconCode,
        temperature: current.temperature,
        isNow: true,
      ),
    );

    // 2. Generate next 24 hours (1 hour intervals)
    for (int i = 1; i <= 24; i++) {
      final targetTime = now.add(Duration(hours: i));

      ForecastItemEntity? before;
      ForecastItemEntity? after;

      for (int j = 0; j < forecast.items.length; j++) {
        if (forecast.items[j].dateTime.isAfter(targetTime)) {
          after = forecast.items[j];
          if (j > 0) {
            before = forecast.items[j - 1];
          }
          break;
        }
      }

      if (after == null) continue;

      DateTime timeBefore;
      double tempBefore;
      String iconBefore;

      if (before == null) {
        timeBefore = now;
        tempBefore = current.temperature;
        iconBefore = current.iconCode;
      } else {
        timeBefore = before.dateTime;
        tempBefore = before.temperature;
        iconBefore = before.iconCode;
      }

      final timeAfter = after.dateTime;
      final tempAfter = after.temperature;

      final totalDiff = timeAfter.difference(timeBefore).inMinutes;
      final targetDiff = targetTime.difference(timeBefore).inMinutes;

      double interpolatedTemp;
      if (totalDiff == 0) {
        interpolatedTemp = tempBefore;
      } else {
        final ratio = targetDiff / totalDiff;
        interpolatedTemp = tempBefore + (tempAfter - tempBefore) * ratio;
      }

      final iconCode = (targetDiff > totalDiff / 2)
          ? after.iconCode
          : iconBefore;

      result.add(
        _HourlyDisplayData(
          time: '${targetTime.hour.toString().padLeft(2, '0')}:00',
          iconCode: iconCode,
          temperature: interpolatedTemp,
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastState = ref.watch(forecastProvider);
    final weatherState = ref.watch(weatherProvider);

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: 110, // Adjusted height for hourly item
        child: forecastState.when(
          data: (forecast) {
            final currentWeather = weatherState.value;
            if (forecast == null || currentWeather == null) {
              return const SizedBox();
            }

            final items = _generateHourlyData(currentWeather, forecast);

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return _HourlyItem(
                  time: item.time,
                  iconCode: item.iconCode,
                  temperature: '${item.temperature.toStringAsFixed(0)}°',
                  isActive: item.isNow,
                );
              },
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(color: context.glass.iconPrimary),
          ),
          error: (err, _) => Center(
            child: Text(
              'Could not load forecast',
              style: TextStyle(color: context.glass.textSecondary),
            ),
          ),
        ),
      ),
    ).animate().slideY(
      begin: 1,
      end: 0,
      duration: 600.ms,
      delay: 300.ms,
      curve: Curves.easeOutCubic,
    );
  }
}

class _HourlyItem extends StatelessWidget {
  final String time;
  final String iconCode;
  final String temperature;
  final bool isActive;

  const _HourlyItem({
    required this.time,
    required this.iconCode,
    required this.temperature,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1)
            : Border.all(color: Colors.transparent, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Image.asset(
            'assets/icons/$iconCode.png',
            width: 32,
            height: 32,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.cloud_rounded, color: Colors.white, size: 28);
            },
          ),
          Text(
            temperature,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
