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
    return LineChart(
      LineChartData(
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
            shadow: Shadow(
              color: Colors.cyanAccent.withAlpha(150),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            isStrokeCapRound: true,
            preventCurveOverShooting: true,
            isCurved: true,
            barWidth: 5,
            dotData: const FlDotData(show: false),
            spots: days
                .map(
                  (e) => FlSpot(
                    DateTime.parse(e.range.date)
                        .millisecondsSinceEpoch
                        .toDouble(),
                    e.grandTotal.totalSeconds,
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
