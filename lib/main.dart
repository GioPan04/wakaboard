import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/pages/home.dart';
import 'package:flutterwaka/pages/login.dart';
import 'package:flutterwaka/providers/logged_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = await AuthApi.loadUser();

  runApp(ProviderScope(
    overrides: [
      loggedUserProvider.overrideWith((ref) => auth),
    ],
    child: App(
      auth: auth == null,
    ),
  ));
}

class App extends StatelessWidget {
  final bool auth;

  const App({
    required this.auth,
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Waka',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: auth ? '/login' : '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
