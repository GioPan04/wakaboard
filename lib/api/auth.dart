import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterwaka/models/local/account.dart';
import 'package:flutterwaka/models/user.dart';

class AuthApi {
  final Dio dio;
  final FlutterSecureStorage storage;

  const AuthApi(this.dio, this.storage);

  Future<void> _save(Account account) {
    final json = jsonEncode(account.toJson());
    return storage.write(key: 'auth.account', value: json);
  }

  Future<Account?> load() async {
    final json = await storage.read(key: 'auth.account');
    if (json == null) return null;

    return Account.fromJson(jsonDecode(json));
  }

  Future<User> _wakatimeLogin(String accessToken) async {
    final dio = Dio(BaseOptions(
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ));
    final res = await dio.get('https://wakatime.com/api/v1/users/current');
    return User.fromJson(res.data['data']);
  }

  Future<User> _customLogin(String uri, String token) async {
    final dio = Dio(BaseOptions(
      baseUrl: uri,
      headers: {
        'Authorization': 'Basic $token',
      },
    ));
    final res = await dio.get('/users/current');
    return User.fromJson(res.data['data']);
  }

  Future<User> login(Account account) {
    return switch (account) {
      AccountWakatime(:final accessToken) => _wakatimeLogin(accessToken),
      AccountCustom(:final serverUrl, :final apiKey) =>
        _customLogin(serverUrl, apiKey),
      AccountData() => throw UnimplementedError(),
    };
  }

  Future<User> logon(Account account) async {
    final user = await login(account);
    await _save(account);

    return user;
  }

  Future<void> logout() {
    return storage.delete(key: 'auth.account');
  }
}
