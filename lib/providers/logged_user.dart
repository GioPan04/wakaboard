import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterwaka/models/user.dart';

final loggedUserProvider = StateProvider<AuthUser?>((ref) => null);

Future<AuthUser?> loadUser() async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final token = await storage.read(key: 'auth.token');
  if (token == null) return null;

  final dio = Dio(BaseOptions(
    headers: {
      'Authorization': 'Bearer $token',
    },
  ));
  final res = await dio.get('https://wakatime.com/api/v1/users/current');
  final user = User.fromJson(res.data);

  return AuthUser(user, token);
}
