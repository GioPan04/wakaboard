import 'package:dio/dio.dart';
import 'package:flutterwaka/models/local/session.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

class AuthUser {
  final User user;
  final Session session;

  AuthUser(this.user, this.session);

  BaseOptions get dioBaseOptions => session.dioBaseOptions;
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
