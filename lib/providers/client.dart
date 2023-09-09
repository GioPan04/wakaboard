import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/providers/logged_user.dart';

final clientProvider = StateProvider<Dio?>((ref) {
  final auth = ref.watch(loggedUserProvider);

  if (auth == null) return null;

  final options = BaseOptions(
    baseUrl: 'https://wakatime.com/api/v1',
    headers: {
      'Authorization': 'Bearer ${auth.token}',
    },
  );

  return Dio(options);
});
