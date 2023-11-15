import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

abstract class AuthUser {
  final User user;
  final String token;

  AuthUser(this.user, this.token);

  BaseOptions get dioBaseOptions;
}

class WakatimeAuthUser extends AuthUser {
  WakatimeAuthUser(User user, String token) : super(user, token);

  @override
  BaseOptions get dioBaseOptions => BaseOptions(
        baseUrl: 'https://wakatime.com/api/v1',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
}

class CustomAuthUser extends AuthUser {
  final String baseUri;

  CustomAuthUser(User user, String token, this.baseUri) : super(user, token);

  @override
  BaseOptions get dioBaseOptions => BaseOptions(
        baseUrl: baseUri,
        headers: {
          'Authorization': 'Basic $token',
        },
      );
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
