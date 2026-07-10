import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeatherLineChart extends StatelessWidget {
  final List<double> temperatures;
  final List<String> timeLabels;
  final List<String> iconCodes;
  final double minTemp;
  final double maxTemp;

  const WeatherLineChart({
    super.key,
    required this.temperatures,
    required this.timeLabels,
    required this.iconCodes,
    required this.minTemp,
    required this.maxTemp,
  });

  @override
  Widget build(BuildContext context) {
    if (temperatures.isEmpty) return const SizedBox();

    final minY = (minTemp - 2).floorToDouble();
    final maxY = (maxTemp + 2).ceilToDouble();

    int minIndex = 0;
    int maxIndex = 0;
    for (int i = 0; i < temperatures.length; i++) {
      if (temperatures[i] == minTemp) minIndex = i;
      if (temperatures[i] == maxTemp) maxIndex = i;
    }

    final spots = temperatures.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16.0,
          left: 8.0,
          top: 32.0,
          bottom: 12.0,
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 3,
              verticalInterval: 1, // draw grid line for each point
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 3,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    if (value == minY || value == maxY) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      '${value.toInt()}°',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < iconCodes.length) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          'assets/icons/${iconCodes[index]}.png',
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.cloud,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 16,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 2,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < timeLabels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          timeLabels[index],
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                ),
                right: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                ),
                top: BorderSide.none,
                left: BorderSide.none,
              ),
            ),
            minX: 0,
            maxX: (temperatures.length - 1).toDouble(),
            minY: minY,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.orange,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    return spot.x.toInt() == minIndex ||
                        spot.x.toInt() == maxIndex;
                  },
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.transparent,
                      strokeWidth: 2,
                      strokeColor: Theme.of(context).colorScheme.onSurface,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withValues(alpha: 0.5),
                      Colors.orange.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: const LineTouchData(enabled: false),
          ),
        ),
      ),
    );
  }
}
