class EndedChatingList {
  final int id;
  final int debateId;
  final int userId;
  final String content;
  final bool checked;
  final String createdAt;
  final String updatedAt;

  EndedChatingList({
    required this.id,
    required this.debateId,
    required this.userId,
    required this.content,
    required this.checked,
    required this.createdAt,
    required this.updatedAt,
  });

  // 'data' 없이 JSON 키에 바로 접근
  factory EndedChatingList.fromJson(Map<String, dynamic> json) {
    return EndedChatingList(
      id: json['id'] ?? 0,
      debateId: json['debateId'] ?? 0,
      userId: json['userId'] ?? 0,
      content: json['content'] ?? '',
      checked: json['checked'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateId': debateId,
      'userId': userId,
      'content': content,
      'checked': checked,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
