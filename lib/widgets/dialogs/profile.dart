import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/package_info.dart';
import 'package:flutterwaka/widgets/avatar.dart';
import 'package:flutterwaka/extensions/duration.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileDialog extends ConsumerStatefulWidget {
  const ProfileDialog({super.key});

  @override
  ProfileDialogState createState() => ProfileDialogState();
}

class ProfileDialogState extends ConsumerState {
  @override
  void initState() {
    super.initState();
    // Refresh the values
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.invalidate(statsProvider);
    });
  }

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

  void _openSettings(BuildContext context) {
    context.pop();
    context.push('/settings');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedUserProvider)!.user;
    final avatar = ref.watch(profilePicProvider).valueOrNull;
    final stats = ref.watch(statsProvider).valueOrNull;
    final packageInfo = ref.read(packageInfoProvider);

    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
          theme.colorScheme.surface,
          Colors.black54, // dialog barrier color
          6.0, // dialog elevation
        ),
      ),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Avatar(
                      image: avatar,
                      radius: 24,
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
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(LucideIcons.settings),
                title: const Text('Settings'),
                onTap: () => _openSettings(context),
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
                      Text(
                          "${packageInfo.version} (${packageInfo.buildNumber})"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
