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

    return _wakatimeLogin(token);
  }

  static Future<WakatimeAuthUser?> _wakatimeLogin(String token) async {
    final dio = Dio(BaseOptions(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ));
    final res = await dio.get('https://wakatime.com/api/v1/users/current');
    final user = User.fromJson(res.data['data']);

    return WakatimeAuthUser(user, token);
  }

  static Future<CustomAuthUser?> _customLogin(String token, String uri) async {
    final dio = Dio(BaseOptions(
      baseUrl: uri,
      headers: {
        'Authorization': 'Basic $token',
      },
    ));
    final res = await dio.get('/users/current');
    final user = User.fromJson(res.data['data']);

    return CustomAuthUser(user, token, uri);
  }

  static Future<WakatimeAuthUser?> wakatimeLogin(String token) async {
    final user = await _wakatimeLogin(token);
    if (user == null) return null;
    await _secureStorage.write(key: accessTokenKey, value: token);
    return user;
  }

  static Future<CustomAuthUser?> customLogin(String token, String base) async {
    final user = await _customLogin(token, base);
    if (user == null) return null;
    await _secureStorage.write(key: accessTokenKey, value: token);
    return user;
  }

  static Future<void> logout() async {
    await _secureStorage.delete(key: accessTokenKey);
  }
}
