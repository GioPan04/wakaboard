import 'package:json_annotation/json_annotation.dart';

part 'repository.g.dart';

@JsonSerializable(createToJson: false)
class Repository {
  final String id;
  final String name;
  final String fullName;
  final String htmlUrl;

  const Repository({
    required this.id,
    required this.name,
    required this.fullName,
    required this.htmlUrl,
  });

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);
}
