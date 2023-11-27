import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/models/stats.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/package_info.dart';
import 'package:flutterwaka/widgets/avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

final statsProvider = FutureProvider<Duration>((ref) async {
  final api = ref.watch(apiProvider)!;
  final stats = await api.getStats(StatsRange.allTime);

  return stats.total;
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loggedUserProvider)!.user;
    final stats = ref.watch(statsProvider);
    final photo = ref.watch(profilePicProvider);
    final packageInfo = ref.read(packageInfoProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: [
        Row(
          children: [
            if (photo.hasValue && photo.value != null)
              Avatar(image: photo.value),
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
            ref.read(loggedUserProvider.notifier).state = null;
          }),
          title: const Text('Logout'),
          leading: const Icon(LucideIcons.logOut),
        ),
        ListTile(
          onTap: () => showLicensePage(
            context: context,
            applicationName: packageInfo.appName,
            applicationVersion:
                'v${packageInfo.version} (${packageInfo.buildNumber})',
          ),
          title: const Text('Licenses'),
          leading: const Icon(LucideIcons.book),
        ),
        ListTile(
          onTap: () => launchUrlString(
            "https://github.com/GioPan04/wakaboard",
          ),
          title: const Text('Contribute on GitHub'),
          leading: const Icon(LucideIcons.github),
        )
      ],
    );
  }
}
