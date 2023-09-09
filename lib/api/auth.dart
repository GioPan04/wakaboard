import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterwaka/models/user.dart';

class AuthApi {
  static const String accessTokenKey = 'auth.token';
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static Future<AuthUser?> loadUser() async {
    final token = await _secureStorage.read(key: 'auth.token');
    if (token == null) return null;

    return _login(token);
  }

  static Future<AuthUser?> _login(String token) async {
    final dio = Dio(BaseOptions(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    final res = await dio.get('https://wakatime.com/api/v1/users/current');
    final user = User.fromJson(res.data['data']);

    return AuthUser(user, token);
  }

  static Future<AuthUser?> login(String token) async {
    final user = await _login(token);
    if (user == null) return null;
    _secureStorage.write(key: accessTokenKey, value: token);
    return user;
  }
}
