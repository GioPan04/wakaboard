import 'package:flutterwaka/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'heartbeat.g.dart';

@JsonSerializable(createToJson: false)
class Heartbeat {
  final String id;
  final Category category;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final String? entity;
  final String? project;
  final String? language;
  final double time;

  Heartbeat({
    required this.id,
    this.entity,
    this.project,
    this.language,
    required this.category,
    required this.createdAt,
    required this.time,
  });

  factory Heartbeat.fromJson(Map<String, dynamic> json) =>
      _$HeartbeatFromJson(json);
}
