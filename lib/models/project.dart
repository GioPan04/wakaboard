import 'package:flutterwaka/models/repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable(createToJson: false)
class Project {
  final String id;
  final String name;
  @JsonKey(name: 'last_heartbeat_at')
  final DateTime? lastHeartbeat;
  final Repository? repository;

  const Project({
    required this.id,
    required this.name,
    this.lastHeartbeat,
    this.repository,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
