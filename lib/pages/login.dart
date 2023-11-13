import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/models/user.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/services/wakatime_oauth.dart';
import 'package:flutterwaka/widgets/or_separator.dart';
import 'package:go_router/go_router.dart';

final _customServerProvider = StateProvider((ref) => false);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  Future<WakatimeAuthUser> _wakatimeLogin() async {
    final accessToken = await WakaTimeOAuth.launch();
    if (accessToken == null) throw Exception('No access token');

    final user = await AuthApi.wakatimeLogin(accessToken);
    if (user == null) throw Exception('No user');

    ref.read(loggedUserProvider.notifier).state = user;

    return user;
  }

  Future<CustomAuthUser> _customLogin(String baseUri, String token) async {
    final user = await AuthApi.customLogin(baseUri, token);
    if (user == null) throw Exception('No user');

    ref.read(loggedUserProvider.notifier).state = user;

    return user;
  }

  Future? _loginFuture;
  final _baseApiUriController = TextEditingController();
  final _apiTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customServer = ref.watch(_customServerProvider);

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
                              final future = _wakatimeLogin().then(
                                (user) => context.go('/home'),
                              );

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
                                  _apiTokenController.text,
                                  _baseApiUriController.text,
                                )
                                    .then(
                                      (user) => context.go('/home'),
                                    )
                                    .catchError((e) => print(e));

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
