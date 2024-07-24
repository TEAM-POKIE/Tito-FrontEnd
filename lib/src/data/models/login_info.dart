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
      id: json['id'] ?? 0, // Provide a default value if null
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profilePicture: json['profilePicture'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      tutorialCompleted: json['tutorialCompleted'] ?? false,
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

  LoginInfo copyWith({
    int? id,
    String? nickname,
    String? email,
    String? role,
    String? profilePicture,
    String? createdAt,
    String? updatedAt,
    bool? tutorialCompleted,
  }) {
    return LoginInfo(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
    );
  }
}
