class LoginInfo {
  const LoginInfo({
    required this.id,
    required this.nickname,
    required this.email,
    required this.role,
    this.profilePicture, // Make profilePicture nullable
    required this.createdAt,
    required this.updatedAt,
    required this.tutorialCompleted,
  });

  final int id;
  final String nickname;
  final String email;
  final String role;
  final String? profilePicture; // Make profilePicture nullable
  final String createdAt;
  final String updatedAt;
  final bool tutorialCompleted;

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      id: json['id'],
      nickname: json['nickname'],
      email: json['email'],
      role: json['role'],
      profilePicture: json['profilePicture'], // Allow null values
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      tutorialCompleted: json['tutorialCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'role': role,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'tutorialCompleted': tutorialCompleted,
    };
  }
}
