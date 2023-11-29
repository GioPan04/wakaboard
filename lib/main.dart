import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/api/sessions.dart';
import 'package:flutterwaka/providers/auth.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/package_info.dart';
import 'package:flutterwaka/providers/router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await openDatabase(
    'wakaboard.db',
    version: 1,
    onCreate: (db, _) => SessionsManager.create(db),
  );

  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final sessionsManager = SessionsManager(db: db, tokensStorage: secureStorage);
  final authApi = AuthApi(sessions: sessionsManager);

  final auth = await authApi.autoLogin().onError((e, s) {
    print("$e\n$s");
    return null;
  });
  final packageInfo = await PackageInfo.fromPlatform();

  runApp(ProviderScope(
    overrides: [
      secureStorageProvider.overrideWithValue(secureStorage),
      authApiProvider.overrideWithValue(authApi),
      packageInfoProvider.overrideWithValue(packageInfo),
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

  final seedColor = const Color(0xFF047857);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider(auth));

    return MaterialApp.router(
      title: 'Flutter Waka',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: seedColor,
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
