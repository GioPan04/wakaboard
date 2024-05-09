import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutterwaka/models/config/wakatime_config.dart';

class WakaTimeOAuth {
  static final url = Uri.https(
    'wakatime.com',
    '/oauth/authorize',
    {
      'client_id': WakaTimeConfig.appId,
      'redirect_uri': WakaTimeConfig.redirect,
      'scope': WakaTimeConfig.scopes.join(','),
      'response_type': 'code',
    },
  );

  /// Opens a web login window to login with WakaTime
  /// and returns the access token
  static Future<String?> launch() async {
    final res = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: 'flutterwaka',
    );

    final params = Uri.parse(res);
    return params.queryParameters['code'];
  }
}
