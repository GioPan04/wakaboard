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
            leading: const Icon(LucideIcons.users),
            title: const Text('Accounts'),
            subtitle: const Text('Add or remove accounts'),
            onTap: () => context.push('/settings/accounts'),
          ),
        ],
      ),
    );
  }
}
