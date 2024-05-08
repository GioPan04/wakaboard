import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/models/local/account.dart';
import 'package:flutterwaka/models/user.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/services/wakatime_oauth.dart';
import 'package:flutterwaka/widgets/exception.dart';
import 'package:flutterwaka/widgets/or_separator.dart';
import 'package:go_router/go_router.dart';

final _customServerProvider = StateProvider((ref) => false);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  Future<void> _wakatimeLogin(AuthApi api) async {
    final accessToken = await WakaTimeOAuth.launch();
    if (accessToken == null) throw Exception('No access token');

    final account = Account.wakatime(accessToken: accessToken);
    final user = await api.logon(account);

    ref.read(loggedUserProvider.notifier).state = AuthUser(user, account);
  }

  Future<void> _customLogin(AuthApi api, String baseUri, String token) async {
    try {
      final account = Account.custom(
        serverUrl: baseUri,
        apiKey: base64Encode(utf8.encode(token)),
      );
      final user = await api.logon(account);
      ref.read(loggedUserProvider.notifier).state = AuthUser(user, account);
    } catch (e, s) {
      if (!mounted) rethrow;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An error occured'),
          action: SnackBarAction(
            label: "Details",
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ExceptionDialog(
                error: e,
                stacktrace: s,
              ),
            ),
          ),
        ),
      );

      rethrow;
    }
  }

  Future? _loginFuture;
  final _baseApiUriController = TextEditingController();
  final _apiTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customServer = ref.watch(_customServerProvider);
    final authApi = ref.read(authApiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: FutureBuilder(
            future: _loginFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...!customServer
                      ? [
                          FilledButton(
                            onPressed: () {
                              final future = _wakatimeLogin(authApi)
                                  .then((_) => context.go('/home'));

                              setState(() {
                                _loginFuture = future;
                              });
                            },
                            child: const Text('Login with WakaTime'),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Login with your WakaTime account hosted on wakatime.com',
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: OrSeparator(),
                          ),
                        ]
                      : [
                          TextField(
                            controller: _baseApiUriController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Base API URI",
                              hintText:
                                  "https://example.com/api/compat/wakatime/v1",
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextField(
                            controller: _apiTokenController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "API token",
                            ),
                          ),
                          const SizedBox(height: 8.0),
                        ],
                  Row(
                    mainAxisAlignment: !customServer
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (customServer)
                        BackButton(
                            onPressed: () => ref
                                .read(_customServerProvider.notifier)
                                .state = false),
                      FilledButton(
                        onPressed: !customServer
                            ? () => ref
                                .read(_customServerProvider.notifier)
                                .state = true
                            : () {
                                final future = _customLogin(
                                  authApi,
                                  _baseApiUriController.text,
                                  _apiTokenController.text,
                                ).then((_) => context.go('/home'));

                                setState(() {
                                  _loginFuture = future;
                                });
                              },
                        child: const Text('Login with custom server'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Currently supported server implementations: Wakapi\nOther servers may not work',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
