final class AuthUser {
  final User user;
  final String token;

  AuthUser(this.user, this.token);
}

final class User {
  final String id;
  final String? email;
  final String photo;
  final String fullName;
  final String username;

  const User({
    required this.id,
    required this.photo,
    required this.fullName,
    required this.username,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      photo: json['photo'],
      fullName: json['full_name'],
      username: json['username'],
      email: json['email'],
    );
  }
}
