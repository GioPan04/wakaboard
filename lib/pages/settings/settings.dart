import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/widgets/dialogs/confirm_logout.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authApi = ref.read(authApiProvider);
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
          ListTile(
            leading: const Icon(LucideIcons.logOut),
            title: const Text('Logout'),
            subtitle: const Text('Logout from your account'),
            onTap: () async {
              final res = await showDialog(
                context: context,
                builder: (context) => const ConfirmLogoutDialog(),
              );

              if (res) {
                await authApi.logout();
                ref.read(loggedUserProvider.notifier).state = null;
                if (!context.mounted) return;
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
