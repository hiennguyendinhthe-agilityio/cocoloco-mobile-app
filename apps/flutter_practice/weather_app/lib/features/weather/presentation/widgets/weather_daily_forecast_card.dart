import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:weather_app/features/weather/presentation/widgets/daily_forecast_detail_sheet.dart';
import 'package:weather_app/features/weather/presentation/widgets/glass_card.dart';

class _DailyDisplayData {
  final DateTime date;
  final String condition;
  final String iconCode;
  final double maxTemp;
  final double minTemp;
  final double pop;
  final double windSpeed;
  final int humidity;

  _DailyDisplayData({
    required this.date,
    required this.condition,
    required this.iconCode,
    required this.maxTemp,
    required this.minTemp,
    required this.pop,
    required this.windSpeed,
    required this.humidity,
  });
}

class WeatherDailyForecastCard extends ConsumerWidget {
  const WeatherDailyForecastCard({super.key});

  List<_DailyDisplayData> _groupDailyData(ForecastEntity forecast) {
    final Map<String, List<ForecastItemEntity>> grouped = {};

    // Group by YYYY-MM-DD
    for (var item in forecast.items) {
      final dateKey = DateFormat('yyyy-MM-dd').format(item.dateTime);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(item);
    }

    final List<_DailyDisplayData> result = [];
    grouped.forEach((dateKey, items) {
      // Optional: skip today if we only want future days, but design shows today too

      double maxTemp = items.first.maxTemp;
      double minTemp = items.first.minTemp;
      double maxPop = items.first.pop;
      double totalWind = 0;
      int totalHumidity = 0;

      // Frequency map to find most common icon/condition
      final iconFreq = <String, int>{};
      final conditionFreq = <String, int>{};

      for (var item in items) {
        if (item.maxTemp > maxTemp) maxTemp = item.maxTemp;
        if (item.minTemp < minTemp) minTemp = item.minTemp;
        if (item.pop > maxPop) maxPop = item.pop;
        totalWind += item.windSpeed;
        totalHumidity += item.humidity;

        iconFreq[item.iconCode] = (iconFreq[item.iconCode] ?? 0) + 1;
        conditionFreq[item.condition] =
            (conditionFreq[item.condition] ?? 0) + 1;
      }

      final avgWind = totalWind / items.length;
      final avgHumidity = (totalHumidity / items.length).round();

      // Get most frequent icon and condition
      String dominantIcon = items.first.iconCode;
      int maxIconCount = 0;
      iconFreq.forEach((icon, count) {
        if (count > maxIconCount) {
          maxIconCount = count;
          dominantIcon = icon;
        }
      });

      String dominantCondition = items.first.condition;
      int maxCondCount = 0;
      conditionFreq.forEach((cond, count) {
        if (count > maxCondCount) {
          maxCondCount = count;
          dominantCondition = cond;
        }
      });

      result.add(
        _DailyDisplayData(
          date: items.first.dateTime,
          condition: dominantCondition,
          iconCode: dominantIcon,
          maxTemp: maxTemp,
          minTemp: minTemp,
          pop: maxPop,
          windSpeed: avgWind,
          humidity: avgHumidity,
        ),
      );
    });

    return result;
  }

  String _toTitleCase(String s) => s
      .split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastState = ref.watch(forecastProvider);

    return GlassCard(
      child: forecastState.when(
        data: (forecast) {
          if (forecast == null) return const SizedBox();
          final dailyData = _groupDailyData(forecast);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.format_list_bulleted_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.sevenDayForecast,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Daily Items
              ...dailyData.expand(
                (day) => [
                  _DailyItem(
                    data: day,
                    toTitleCase: _toTitleCase,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => DailyForecastDetailSheet(
                          forecast: forecast,
                          initialSelectedDate: day.date,
                        ),
                      );
                    },
                  ),
                  if (day != dailyData.last) const SizedBox(height: 20),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              context.l10n.couldNotLoadForecast,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    ).animate().slideY(
      begin: 1,
      end: 0,
      duration: 600.ms,
      delay: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }
}

class _DailyItem extends StatelessWidget {
  final _DailyDisplayData data;
  final String Function(String) toTitleCase;
  final VoidCallback onTap;

  const _DailyItem({
    required this.data,
    required this.toTitleCase,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEE').format(data.date);
    final monthDay = DateFormat('MMM d').format(data.date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            // Date & Condition & POP
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$dayName, $monthDay',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    toTitleCase(data.condition),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop_rounded,
                        color: Colors.blue[400],
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(data.pop * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Weather Icon
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/icons/${data.iconCode}.png',
                  width: 48,
                  height: 48,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.cloud_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),

            // Right side metrics (Temp, Wind, Humidity)
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Temp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${data.maxTemp.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${data.minTemp.toStringAsFixed(0)}°',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Wind & Humidity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.air_rounded,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${data.windSpeed.toStringAsFixed(0)}m/s',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '|',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.water_drop_outlined,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${data.humidity}%',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
