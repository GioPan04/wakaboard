import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterwaka/api/sessions.dart';
import 'package:flutterwaka/models/user.dart';

class AuthApi {
  final SessionsManager sessions;

  AuthApi({required this.sessions});

  static BaseOptions getBaseOptions(String token, [String? url]) {
    if (url != null) {
      return BaseOptions(
        baseUrl: url,
        headers: {'Authorization': 'Basic $token'},
      );
    } else {
      return BaseOptions(
        baseUrl: 'https://api.wakatime.com/api/v1',
        headers: {'Authorization': 'Bearer $token'},
      );
    }
  }

  /// Try to login a user from a saved session
  Future<AuthUser?> autoLogin() async {
    final account = await sessions.defaultAccount();
    if (account == null) return null;
    final session = await sessions.session(account);

    final dio = Dio(session.dioBaseOptions);
    final res = await dio.get('/users/current');

    return AuthUser(
      User.fromJson(res.data['data']),
      session,
    );
  }

  Future<AuthUser> login(String token, [String? server]) async {
    if (server != null) token = base64.encode(utf8.encode(token));

    final dio = Dio(getBaseOptions(token));
    final res = await dio.get('/users/current');
    final user = User.fromJson(res.data['data']);

    // Right now we are not handling refresh tokens, see #9
    final session = await sessions.save(user, server, token, null);

    return AuthUser(user, session);
  }
}
