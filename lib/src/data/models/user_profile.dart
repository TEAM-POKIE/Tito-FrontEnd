class UserProfile {
  final int id;
  final String nickname;
  final String email;
  final String role;
  String profilePicture;
  final String createdAt;
  final String updatedAt;
  final bool tutorialCompleted;
  final bool quit;
  final int winningRate;
  final int debateTotalCount;
  final int debateVictoryCount;
  final int debateDefeatCount;

  UserProfile({
    required this.id,
    required this.nickname,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.tutorialCompleted,
    required this.quit,
    required this.winningRate,
    required this.debateTotalCount,
    required this.debateVictoryCount,
    required this.debateDefeatCount,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['data']['id'] ?? 0,
      nickname: json['data']['nickname'] ?? '',
      email: json['data']['email'] ?? '',
      role: json['data']['role'] ?? '',
      profilePicture: json['data']['profilePicture'] ?? '',
      createdAt: json['data']['createdAt'] ?? '',
      updatedAt: json['data']['updatedAt'] ?? '',
      tutorialCompleted: json['data']['tutorialCompleted'] ?? false,
      quit: json['data']['quit'] ?? false,
      winningRate: json['data']['winningRate'] ?? 0,
      debateTotalCount: json['data']['debateTotalCount'] ?? 0,
      debateVictoryCount: json['data']['debateVictoryCount'] ?? 0,
      debateDefeatCount: json['data']['debateDefeatCount'] ?? 0,
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
      'quit': quit,
      'winningRate': winningRate,
      'debateTotalCount': debateTotalCount,
      'debateVictoryCount': debateVictoryCount,
      ' debateDefeatCount': debateDefeatCount,
    };
  }
}
