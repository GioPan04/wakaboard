import 'package:dio/dio.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/models/local/dashboard_range.dart';
import 'package:flutterwaka/models/local/settings/dashboard.dart';
import 'package:flutterwaka/models/user.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/package_info.dart';
import 'package:flutterwaka/providers/router.dart';
import 'package:flutterwaka/providers/settings/dashboard.dart';
import 'package:flutterwaka/providers/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add Montserrat font license to licenses page
  final montserratLicense = await rootBundle.loadString(
    'assets/fonts/montserrat/LICENSE.txt',
  );
  LicenseRegistry.addLicense(
    () => Stream<LicenseEntry>.value(
      LicenseEntryWithLineBreaks(
        <String>['Montserrat'],
        montserratLicense,
      ),
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final authApi = AuthApi(Dio(), secureStorage);
  final account = await authApi.load();
  final packageInfo = await PackageInfo.fromPlatform();

  AuthUser? user;
  if (account != null) {
    user = AuthUser(await authApi.login(account), account);
  }

  runApp(ProviderScope(
    overrides: [
      loggedUserProvider.overrideWith((ref) => user),
      packageInfoProvider.overrideWithValue(packageInfo),
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      secureStorageProvider.overrideWithValue(secureStorage),
    ],
    child: App(
      auth: account == null,
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

        final darkScheme = darkDynamic ?? compatDarkScheme;
        final lightScheme = lightDynamic ?? compatLightScheme;

        return MaterialApp.router(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('it'), Locale('en')],
          title: 'Flutter Waka',
          darkTheme: ThemeData(
            fontFamily: "Montserrat",
            useMaterial3: true,
            colorScheme: darkScheme,
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: darkScheme?.background,
              ),
            ),
          ),
          theme: ThemeData(
            fontFamily: "Montserrat",
            colorScheme: lightScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: lightScheme?.background,
              ),
            ),
          ),
          routerConfig: router,
        );
      },
    );
  }
}
