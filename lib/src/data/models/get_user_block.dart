class GetUserBlock {
  final int id;
  final String nickname;
  final String? profilePicture;

  GetUserBlock({required this.id, required this.nickname, this.profilePicture});

  factory GetUserBlock.fromJson(Map<String, dynamic> json) {
    return GetUserBlock(
        id: json['userId'] ?? 0,
        nickname: json['nickname'] ?? '',
        profilePicture: json['profilePicture']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nickname': nickname, 'profilePicture': profilePicture};
  }
}
