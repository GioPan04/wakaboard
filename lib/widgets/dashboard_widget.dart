import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardWidget extends StatelessWidget {
  final String label;
  final Color color;
  final String value;

  const DashboardWidget({
    super.key,
    required this.label,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.background,
              ),
              padding: const EdgeInsets.all(6.0),
              child: const Icon(
                LucideIcons.trendingUp,
                size: 20,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.black.withAlpha(170),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
