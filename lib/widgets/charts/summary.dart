import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:intl/intl.dart';

final format = DateFormat('EEE');

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
              showTitles: days.length <= 15,
              interval: 1,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                final s = days[value.toInt()];
                return Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: meta.min == value ? 5 : 0,
                    right: meta.max == value ? 5 : 0,
                  ),
                  child: Text(
                    format.format(s.range.end).toUpperCase()[0],
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
            spots: days
                .asMap()
                .map(
                  (i, e) => MapEntry(
                    i,
                    FlSpot(
                      i.toDouble(),
                      e.total.inSeconds.toDouble(),
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
