class LoginInfo {
  final int id;
  final String nickname;
  final String email;
  final String role;
  final String? profilePicture;
  final String createdAt;
  final String updatedAt;
  bool tutorialCompleted;

  LoginInfo({
    required this.id,
    required this.nickname,
    required this.email,
    required this.role,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.tutorialCompleted,
  });

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      id: json['data']['id'] ?? 0,
      nickname: json['data']['nickname'] ?? '',
      email: json['data']['email'] ?? '',
      role: json['data']['role'] ?? '',
      profilePicture: json['data']['profilePicture'],
      createdAt: json['data']['createdAt'] ?? '',
      updatedAt: json['data']['updatedAt'] ?? '',
      tutorialCompleted: json['data']['tutorialCompleted'] ?? false,
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
