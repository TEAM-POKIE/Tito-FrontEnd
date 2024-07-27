class User {
  final int id;
  final String nickname;
  final String email;
  final String role;
  final String profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool tutorialCompleted;

  User({
    required this.id,
    required this.nickname,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.tutorialCompleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nickname: json['nickname'],
      email: json['email'],
      role: json['role'],
      profilePicture: json['profilePicture'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tutorialCompleted: json['tutorialCompleted'],
    );
  }
}

class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }
}
