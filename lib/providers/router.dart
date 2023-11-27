import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/pages/timeline.dart';
import 'package:flutterwaka/pages/home.dart';
import 'package:flutterwaka/pages/login.dart';
import 'package:flutterwaka/pages/project.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider.family<GoRouter, bool>(
  (ref, auth) => GoRouter(
    initialLocation: auth ? '/login' : '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/timeline',
        builder: (context, state) => const TimelinePage(),
      ),
      GoRoute(
        path: '/home/projects/:projectId',
        builder: (context, state) => ProjectPage(
          q: state.pathParameters['projectId']!,
        ),
      ),
    ],
  ),
);
