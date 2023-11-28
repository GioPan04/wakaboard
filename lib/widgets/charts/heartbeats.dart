import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutterwaka/models/heartbeat.dart';

class HeartbeatsChart extends StatelessWidget {
  final List<List<Heartbeat>> hours;

  const HeartbeatsChart({required this.hours, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 4,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    value.toInt().toString().padLeft(2, '0'),
                    style: theme.textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            color: theme.colorScheme.onPrimaryContainer.withAlpha(200),
            shadow: Shadow(
              color: theme.colorScheme.primary.withAlpha(150),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
            curveSmoothness: 0.5,
            isStrokeCapRound: true,
            preventCurveOverShooting: true,
            isCurved: true,
            barWidth: 5,
            dotData: const FlDotData(show: false),
            spots: hours
                .asMap()
                .map(
                  (i, e) => MapEntry(
                    i,
                    FlSpot(
                      i.toDouble(),
                      e.length.toDouble(),
                    ),
                  ),
                )
                .values
                .toList(),
          )
        ],
      ),
    );
  }
}
