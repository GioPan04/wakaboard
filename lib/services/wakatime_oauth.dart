import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class WakaTimeOAuth {
  static const appId = 'MBzCVc9hyiqz6KKQjKSJZ2tM';
  static const redirect = 'flutterwaka://auth/redirect';
  static const scopes = [
    'email',
    'read_logged_time',
    'read_stats',
    'read_orgs',
    'read_private_leaderboards'
  ];

  static final url = Uri.https(
    'wakatime.com',
    '/oauth/authorize',
    {
      'client_id': appId,
      'redirect_uri': redirect,
      'scope': scopes.join(','),
      'response_type': 'token',
    },
  );

  /// Opens a web login window to login with WakaTime
  /// and returns the access token
  static Future<String?> launch() async {
    final res = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: 'flutterwaka',
    );

    final params = _parseUri(res, redirect);
    return params['access_token'];
  }

  static Map<String, String> _parseUri(String uri, String redirect) {
    final paramList = uri.replaceFirst('$redirect#', '').split('&');
    final params = <String, String>{};
    for (final p in paramList) {
      final param = p.split('=');
      params[param[0]] = param[1];
    }

    return params;
  }
}
