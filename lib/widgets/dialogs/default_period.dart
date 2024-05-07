import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/local/dashboard_range.dart';
import 'package:flutterwaka/providers/settings/dashboard.dart';
import 'package:go_router/go_router.dart';

final _periodProvider = StateProvider.autoDispose<DashboardRange>(
  (ref) => ref.read(dashboardSettingsProvider).range,
);

class DefaultPeriodDialog extends ConsumerWidget {
  const DefaultPeriodDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final period = ref.watch(_periodProvider);

    return AlertDialog(
      title: const Text('Default date period'),
      contentPadding: const EdgeInsets.only(top: 20, bottom: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 0, color: theme.colorScheme.outline),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: DashboardRange.values.length,
              itemBuilder: (context, i) => RadioListTile<DashboardRange>(
                groupValue: period,
                value: DashboardRange.values[i],
                onChanged: (p) => ref.read(_periodProvider.notifier).state = p!,
                title: Text(DashboardRange.values[i].label),
              ),
            ),
          ),
          Divider(height: 0, color: theme.colorScheme.outline),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => context.pop(),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => context.pop(period),
        )
      ],
    );
  }
}
