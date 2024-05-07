import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/local/dashboard_range.dart';
import 'package:flutterwaka/providers/settings/dashboard.dart';
import 'package:flutterwaka/widgets/dialogs/default_period.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardSettingsPage extends ConsumerWidget {
  const DashboardSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(dashboardSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(LucideIcons.calendar),
            title: const Text('Default date period'),
            subtitle: Text(settings.range.label),
            onTap: () async {
              final value = await showDialog<DashboardRange>(
                context: context,
                builder: (context) => const DefaultPeriodDialog(),
              );

              ref.read(dashboardSettingsProvider.notifier).state =
                  settings.copyWith(range: value ?? settings.range);
            },
          )
        ],
      ),
    );
  }
}
