import 'package:dio/dio.dart';
import 'package:flutterwaka/models/local/account.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

class AuthUser {
  final User user;
  final Account account;

  AuthUser(this.user, this.account);

  BaseOptions get dioBaseOptions => switch (account) {
        AccountWakatime(:final accessToken) => BaseOptions(
            baseUrl: 'https://wakatime.com/api/v1',
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        AccountCustom(:final serverUrl, :final apiKey) => BaseOptions(
            baseUrl: serverUrl,
            headers: {
              'Authorization': 'Basic $apiKey',
            },
          ),
        AccountData() => throw UnimplementedError(),
      };
}

@JsonSerializable(createToJson: false)
class User {
  final String id;
  final String username;
  final String? fullName;
  final String? email;
  final String? photo;

  const User({
    required this.id,
    required this.username,
    this.fullName,
    this.photo,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
