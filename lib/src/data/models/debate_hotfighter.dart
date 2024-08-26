class DebateHotfighter {
  final int userId;
  final String nickname;
  final String? profilePicture;

  DebateHotfighter({
    required this.userId,
    required this.nickname,
    this.profilePicture,
  });

  factory DebateHotfighter.fromJson(Map<String, dynamic> json) {
    return DebateHotfighter(
      userId: json['userId'] ?? 0,
      nickname: json['nickname'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'profilePicture': profilePicture,
    };
  }

  @override
  String toString() {
    return 'DebateHotfighter{userId: $userId, nickname: $nickname, profilePicture: $profilePicture}';
  }
}
