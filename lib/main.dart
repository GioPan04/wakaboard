import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/package_info.dart';
import 'package:flutterwaka/providers/router.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = await AuthApi.loadUser().onError((error, stackTrace) => null);
  final packageInfo = await PackageInfo.fromPlatform();

  runApp(ProviderScope(
    overrides: [
      loggedUserProvider.overrideWith((ref) => auth),
      packageInfoProvider.overrideWithValue(packageInfo),
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

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme? compatLightScheme;
        ColorScheme? compatDarkScheme;

        if (lightDynamic == null) {
          compatLightScheme = ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.light,
          );
        }
        if (darkDynamic == null) {
          compatDarkScheme = ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp.router(
          title: 'Flutter Waka',
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkDynamic ?? compatDarkScheme,
          ),
          theme: ThemeData(
            colorScheme: lightDynamic ?? compatLightScheme,
            useMaterial3: true,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
