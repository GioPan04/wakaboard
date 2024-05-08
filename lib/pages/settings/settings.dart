import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(LucideIcons.layoutDashboard),
            title: const Text('Dashboard'),
            subtitle: const Text('Set your preferences for the dashboard'),
            onTap: () => context.push('/settings/dashboard'),
          ),
        ],
      ),
    );
  }
}
