final class Commit {
  final String committerAvatarUrl;
  final String committerUsername;
  final String htmlUrl;
  final String id;
  final String message;
  final DateTime createdAt;

  const Commit({
    required this.committerAvatarUrl,
    required this.committerUsername,
    required this.htmlUrl,
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
      committerAvatarUrl: json['committer_avatar_url'],
      committerUsername: json['committer_username'],
      htmlUrl: json['html_url'],
      id: json['id'],
      message: json['message'],
      createdAt: DateTime.parse(json['committer_date']),
    );
  }
}
