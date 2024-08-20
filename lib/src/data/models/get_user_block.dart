class GetUserBlock {
  final int blockedUserId;
  final String nickname;
  final String? profilePicture;

  GetUserBlock(
      {required this.blockedUserId,
      required this.nickname,
      this.profilePicture});

  factory GetUserBlock.fromJson(Map<String, dynamic> json) {
    return GetUserBlock(
        blockedUserId: json['blockedUserId'] ?? 0,
        nickname: json['nickname'] ?? '',
        profilePicture: json['profilePicture']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': blockedUserId,
      'nickname': nickname,
      'profilePicture': profilePicture
    };
  }
}
