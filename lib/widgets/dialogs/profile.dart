import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/package_info.dart';
import 'package:flutterwaka/widgets/avatar.dart';
import 'package:flutterwaka/extensions/duration.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileDialog extends ConsumerWidget {
  const ProfileDialog({super.key});

  void _openLicenses(BuildContext context, PackageInfo info) {
    showLicensePage(
      context: context,
      applicationName: info.appName,
      applicationVersion: info.version,
    );
  }

  Future<void> _openContribute() async {
    const url = "https://github.com/GioPan04/wakaboard";
    if (!(await canLaunchUrlString(url))) return;

    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loggedUserProvider)!.user;
    final avatar = ref.watch(profilePicProvider).valueOrNull;
    final stats = ref.watch(statsProvider).valueOrNull;
    final packageInfo = ref.read(packageInfoProvider);

    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Avatar(
                    image: avatar,
                    radius: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName ?? user.username,
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          stats?.format ?? '0 hrs 0 mins',
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.chevronDown),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(LucideIcons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(LucideIcons.book),
              title: const Text('Licenses'),
              onTap: () => _openLicenses(context, packageInfo),
            ),
            ListTile(
              leading: const Icon(LucideIcons.github),
              title: const Text('Contribute on GitHub'),
              onTap: () => _openContribute(),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DefaultTextStyle(
                style: theme.textTheme.bodySmall!,
                child: Column(
                  children: [
                    Text(packageInfo.appName),
                    Text("${packageInfo.version} (${packageInfo.buildNumber})"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
