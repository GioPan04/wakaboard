abstract class WakaTimeConfig {
  static const appId = 'MBzCVc9hyiqz6KKQjKSJZ2tM';
  // Shouldn't be a problem posting this publicly...
  static const appSecret = String.fromEnvironment('WAKABOARD_CLIENT_SECRET');
  static const redirect = 'flutterwaka://auth/redirect';
  static const scopes = [
    'email',
    'read_logged_time',
    'read_stats',
    'read_orgs',
    'read_private_leaderboards'
  ];
}
