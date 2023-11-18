import 'package:flutter/material.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:flutterwaka/widgets/time_counter.dart';
import 'package:flutterwaka/extensions/number.dart';

class SummaryCounter extends StatelessWidget {
  final Summary summary;
  final Summary? previuosSummary;

  final double? totalIncrease;
  final double? averageIncrease;

  SummaryCounter({
    required this.summary,
    this.previuosSummary,
    super.key,
  })  : totalIncrease = previuosSummary == null
            ? null
            : _calculateIncrease(
                summary.comulativeTotal,
                previuosSummary.comulativeTotal,
              ),
        averageIncrease = previuosSummary == null
            ? null
            : _calculateIncrease(
                summary.dailyAverage.duration,
                previuosSummary.dailyAverage.duration,
              );

  static double _calculateIncrease(Duration actual, Duration previous) {
    return (actual.inSeconds - previous.inSeconds) / previous.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: theme.colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              totalIncrease == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        totalIncrease!.asPercentage,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
              TimeCounter(
                duration: summary.comulativeTotal,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'TOTAL',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(width: 1, color: Colors.white10),
              ),
            ),
          ),
          Column(
            children: [
              averageIncrease == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        averageIncrease!.asPercentage,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
              TimeCounter(
                duration: summary.dailyAverage.duration,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'DAILY AVERAGE',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
