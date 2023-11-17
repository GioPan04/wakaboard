import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/models/stats.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

final statsProvider = FutureProvider<Duration>((ref) async {
  final dio = ref.watch(clientProvider)!;
  final res = await dio.get('/users/current/stats/all_time');

  return Stats.fromJson(res.data['data']).total;
});

final profilePicProvider = FutureProvider((ref) async {
  final user = ref.watch(loggedUserProvider)!.user;
  final dio = ref.read(clientProvider)!;

  if (user.photo == null) return null;

  final res = await dio.get(
    "${user.photo}?s=420",
    options: Options(responseType: ResponseType.bytes),
  );

  final contentType = res.headers[Headers.contentTypeHeader]?.first;

  if (contentType == null || !contentType.startsWith('image/')) {
    throw Exception('Unsupported image');
  } else if (contentType == 'image/svg+xml') {
    return utf8.decode(res.data);
  } else {
    return res.data;
  }
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loggedUserProvider)!.user;
    final stats = ref.watch(statsProvider);
    final photo = ref.watch(profilePicProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: [
        Row(
          children: [
            if (photo.hasValue && photo.value != null)
              CircleAvatar(
                radius: 64,
                child: ClipOval(
                  child: photo.value.runtimeType == String
                      ? SvgPicture.string(
                          photo.value,
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                        )
                      : Image.memory(
                          photo.value,
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
            ref.read(loggedUserProvider.notifier).state = null;
          }),
          title: const Text('Logout'),
          leading: const Icon(LucideIcons.logOut),
        ),
        ListTile(
          onTap: () => showLicensePage(context: context),
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
