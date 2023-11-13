import 'package:dio/dio.dart';

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

final class User {
  final String id;
  final String? email;
  final String? photo;
  final String fullName;
  final String username;

  const User({
    required this.id,
    required this.fullName,
    required this.username,
    this.photo,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      photo: json['photo'],
      fullName: json['full_name'] ?? json['username'],
      username: json['username'],
      email: json['email'],
    );
  }
}
