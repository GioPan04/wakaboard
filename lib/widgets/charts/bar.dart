import 'package:flutter/material.dart';
import 'package:flutterwaka/extensions/duration.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/summary.dart';

class BarChart extends StatelessWidget {
  final List<SummaryItem<Project>> items;

  const BarChart({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items
              .asMap()
              .map(
                (i, e) => MapEntry(
                  i,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.name,
                                style: theme.textTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(e.duration.format)
                          ],
                        ),
                        LinearProgressIndicator(
                          value: e.percent / 100,
                          borderRadius: BorderRadius.circular(8.0),
                        )
                      ],
                    ),
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}
