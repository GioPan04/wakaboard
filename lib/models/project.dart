import 'package:flutterwaka/models/repository.dart';

final class Project {
  final String id;
  final String name;
  final DateTime? lastHeartbeat;
  final Repository? repository;

  const Project({
    required this.id,
    required this.name,
    this.lastHeartbeat,
    this.repository,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      lastHeartbeat: json['last_heartbeat_at'] != null
          ? DateTime.parse(json['last_heartbeat_at'])
          : null,
      repository: json['repository'] != null
          ? Repository.fromJson(json['repository'])
          : null,
    );
  }
}
