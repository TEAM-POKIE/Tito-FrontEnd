class Debate {
  final int id;
  final String debateTitle;

  final String debateStatus;
  String? debateImageUrl;
  final double winnerRate;

  Debate({
    required this.id,
    required this.debateTitle,
    required this.debateStatus,
    this.debateImageUrl,
    required this.winnerRate,
  });

  factory Debate.fromJson(Map<String, dynamic> json) {
    return Debate(
      id: json['id'],
      debateTitle: json['debateTitle'],
      debateStatus: json['debateStatus'],
      debateImageUrl: json['debateImageUrl'] ?? "",
      winnerRate: json['winnerRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateTitle': debateTitle,
      'debateStatus': debateStatus,
      'debateImageUrl': debateImageUrl,
      'winnerRate': winnerRate,
    };
  }
}

enum DebateListCategory {
  ROMANCE("연애"),
  POLITICS("정치"),
  ENTERTAINMENT("연예"),
  FREE("자유"),
  SPORTS("스포츠");

  final String displayName;

  const DebateListCategory(this.displayName);

  static DebateListCategory fromString(String category) {
    return DebateListCategory.values.firstWhere((e) => e.name == category,
        orElse: () => DebateListCategory.FREE);
  }

  @override
  String toString() {
    return displayName;
  }
}

enum DebateListStatus {
  CREATED("토론참여가능"),
  IN_PROGRESS("토론 진행중"),
  VOTING("투표 중"),
  ENDED("투표 완료");

  final String displayName;

  const DebateListStatus(this.displayName);

  static DebateListStatus fromString(String status) {
    return DebateListStatus.values.firstWhere((e) => e.name == status,
        orElse: () => DebateListStatus.ENDED);
  }

  @override
  String toString() {
    return displayName;
  }
}
