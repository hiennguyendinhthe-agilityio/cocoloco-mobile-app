import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PrecipitationChart extends StatelessWidget {
  final List<double> popPercentages; // 0.0 to 1.0 or 0 to 100? Let's assume 0 to 100
  final List<String> timeLabels;

  const PrecipitationChart({
    super.key,
    required this.popPercentages,
    required this.timeLabels,
  });

  @override
  Widget build(BuildContext context) {
    if (popPercentages.isEmpty) return const SizedBox();

    final spots = popPercentages.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 8.0, top: 16.0, bottom: 12.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 20,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
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
                  interval: 20,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}%',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
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
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)),
                right: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2)),
                top: BorderSide.none,
                left: BorderSide.none,
              ),
            ),
            minX: 0,
            maxX: (popPercentages.length - 1).toDouble(),
            minY: 0,
            maxY: 100, // Fixed 0 to 100 for percentage
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false, // Straight lines usually for precipitation
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: const LineTouchData(
              enabled: false,
            ),
          ),
        ),
      ),
    );
  }
}
