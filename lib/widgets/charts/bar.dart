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

  Color _calculateBarColor(Color original, int i) {
    final length = items.length;

    return original.withAlpha(
      ((length - i) / length * 200).toInt() + 50,
    );
  }

  TextStyle? _calculateTextStyle(TextTheme theme, int i) {
    return switch (i) {
      0 => theme.headlineSmall,
      1 => theme.bodyLarge,
      _ => theme.bodyMedium,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items
            .asMap()
            .map(
              (i, e) => MapEntry(
                i,
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: CustomPaint(
                    painter: _BarChartPainter(
                      item: e,
                      primaryColor: _calculateBarColor(
                        theme.colorScheme.primaryContainer,
                        i,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              e.name,
                              style: _calculateTextStyle(theme.textTheme, i),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            e.duration.format,
                            style: _calculateTextStyle(theme.textTheme, i),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final SummaryItem item;
  final Color primaryColor;

  const _BarChartPainter({
    required this.item,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = primaryColor;
    final rect = Rect.fromLTRB(
      0,
      0,
      item.percent / 100 * size.width,
      size.height,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: const Radius.circular(3),
        bottomRight: const Radius.circular(3),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_BarChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_BarChartPainter oldDelegate) => false;
}
