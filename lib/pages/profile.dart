import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/models/stats.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

final statsProvider = FutureProvider<Duration>((ref) async {
  final dio = ref.read(clientProvider)!;
  final res = await dio.get('/users/current/stats/all_time');

  return Stats.fromJson(res.data['data']).total;
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loggedUserProvider)!.user;
    final stats = ref.watch(statsProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Row(
            children: [
              if (user.photo != null)
                CircleAvatar(
                  radius: 64,
                  child: ClipOval(
                    child: Image.network(
                      "${user.photo}?s=420",
                    ),
                  ),
                ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: theme.textTheme.titleLarge,
                  ),
                  if (stats.hasValue)
                    Text(
                      '${stats.value!.inHours} hrs ${stats.value!.inMinutes.remainder(60)} mins',
                    ),
                ],
              )
            ],
          ),
          ListTile(
            onTap: () => AuthApi.logout().then((_) {
              context.go('/login');
              // ref.read(loggedUserProvider.notifier).state = null;
            }),
            title: const Text('Logout'),
            leading: const Icon(LucideIcons.logOut),
          ),
          ListTile(
            onTap: () => showLicensePage(context: context),
            title: const Text('Licenses'),
            leading: const Icon(LucideIcons.book),
          )
        ],
      ),
    );
  }
}
