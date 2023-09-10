import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:go_router/go_router.dart';

final _loginProvider = AsyncNotifierProvider<_AuthNotifier, String?>(
  () => _AuthNotifier(),
);

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final login = ref.watch(_loginProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: FilledButton(
          onPressed: () => ref.read(_loginProvider.notifier).login().then(
            (value) {
              if (value != null) {
                context.go('/home');
              }
            },
          ),
          child: const Text('Login with WakaTime'),
        ),
      ),
    );
  }
}

class _AuthNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() {
    return Future.value();
  }

  Future login() async {
    state = const AsyncValue.loading();

    const appId = 'MBzCVc9hyiqz6KKQjKSJZ2tM';
    const redirect = 'flutterwaka://auth/redirect';
    const scopes = [
      'email',
      'read_logged_time',
      'read_stats',
      'read_orgs',
      'read_private_leaderboards'
    ];

    final url = Uri.https(
      'wakatime.com',
      '/oauth/authorize',
      {
        'client_id': appId,
        'redirect_uri': redirect,
        'scope': scopes.join(','),
        'response_type': 'token',
      },
    );

    final res = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: 'flutterwaka',
    );

    final params = _parseUri(res, redirect);
    final accessToken = params['access_token']!;
    final user = await AuthApi.login(accessToken);

    ref.read(loggedUserProvider.notifier).state = user;
    state = AsyncValue.data(res);

    return user;
  }

  Map<String, String> _parseUri(String uri, String redirect) {
    final paramList = uri.replaceFirst('$redirect#', '').split('&');
    final params = <String, String>{};
    for (final p in paramList) {
      final param = p.split('=');
      params[param[0]] = param[1];
    }

    return params;
  }
}
