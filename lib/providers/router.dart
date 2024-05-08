import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/pages/intro/welcome.dart';
import 'package:flutterwaka/pages/settings/accounts.dart';
import 'package:flutterwaka/pages/settings/dashboard.dart';
import 'package:flutterwaka/pages/settings/settings.dart';
import 'package:flutterwaka/pages/home.dart';
import 'package:flutterwaka/pages/login.dart';
import 'package:flutterwaka/pages/project.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider.family<GoRouter, bool>(
  (ref, auth) => GoRouter(
    initialLocation: auth ? '/intro/welcome' : '/home',
    routes: [
      GoRoute(
        path: '/intro/welcome',
        builder: (context, state) => const WelcomeIntroPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/home/projects/:projectId',
        builder: (context, state) => ProjectPage(
          q: state.pathParameters['projectId']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/settings/dashboard',
        builder: (context, state) => const DashboardSettingsPage(),
      ),
    ],
  ),
);
