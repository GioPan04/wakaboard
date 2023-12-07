import 'package:dio/dio.dart';
import 'package:flutterwaka/models/local/account.dart';

class Session {
  final Account account;
  final String accessToken;
  final String? refreshToken;

  Session({
    required this.account,
    required this.accessToken,
    this.refreshToken,
  });

  BaseOptions get dioBaseOptions {
    if (account.isCustomServer) {
      return BaseOptions(
        baseUrl: account.server!,
        headers: {'Authorization': 'Basic $accessToken'},
      );
    } else {
      return BaseOptions(
        baseUrl: 'https://api.wakatime.com/api/v1',
        headers: {'Authorization': 'Bearer $accessToken'},
      );
    }
  }
}
