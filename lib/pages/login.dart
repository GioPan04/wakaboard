import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

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
          onPressed: () => ref.read(_loginProvider.notifier).login(),
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
    const redirect = 'http://localhost:8080/auth/redirect';
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
        'response_type': 'code',
      },
    );

    final res = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: 'http://localhost:8080/auth/login',
    );

    state = AsyncValue.data(res);

    print(res);
  }
}
