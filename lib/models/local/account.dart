import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final int id;
  final String? server;
  final String username;
  @JsonKey(name: 'full_name')
  final String? fullName;

  const Account({
    required this.id,
    required this.username,
    this.server,
    this.fullName,
  });

  factory Account.fromDb(Map<String, dynamic> s) => _$AccountFromJson(s);
  Map<String, dynamic> toDb() => _$AccountToJson(this);

  bool get isCustomServer => server != null;
}
