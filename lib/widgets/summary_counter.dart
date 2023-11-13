import 'package:flutter/material.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:flutterwaka/widgets/time_counter.dart';

class SummaryCounter extends StatelessWidget {
  final Summary summary;

  const SummaryCounter({
    required this.summary,
    super.key,
  });

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
              TimeCounter(
                duration: summary.comulativeTotal.duration,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'TOTAL',
                style: theme.textTheme.labelMedium,
              )
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
              TimeCounter(
                duration: summary.dailyAverage.duration,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'DAILY AVERAGE',
                style: theme.textTheme.labelMedium,
              )
            ],
          ),
        ],
      ),
    );
  }
}
