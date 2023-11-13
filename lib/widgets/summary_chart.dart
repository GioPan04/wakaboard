import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:intl/intl.dart';

final format = DateFormat('EEE dd');

class SummaryChart extends StatelessWidget {
  final List<SummaryDay> days;

  const SummaryChart({required this.days, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            color: theme.colorScheme.primary,
            shadow: Shadow(
              color: theme.colorScheme.primary.withAlpha(150),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            curveSmoothness: 0.5,
            isStrokeCapRound: true,
            preventCurveOverShooting: true,
            isCurved: true,
            barWidth: 5,
            dotData: const FlDotData(show: false),
            spots: days
                .asMap()
                .map(
                  (i, e) => MapEntry(
                    i,
                    FlSpot(
                      i.toDouble(),
                      e.total.duration.inSeconds.toDouble(),
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
