import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = await AuthApi.loadUser().onError((error, stackTrace) => null);

  runApp(ProviderScope(
    overrides: [
      loggedUserProvider.overrideWith((ref) => auth),
    ],
    child: App(
      auth: auth == null,
    ),
  ));
}

class App extends ConsumerWidget {
  final bool auth;

  const App({
    required this.auth,
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider(auth));

    return MaterialApp.router(
      title: 'Flutter Waka',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
