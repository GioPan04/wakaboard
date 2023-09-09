final class Repository {
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

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
      htmlUrl: json['html_url'],
    );
  }
}
