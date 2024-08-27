class Debate {
  final int id;
  final String debateTitle;
  final String debateStatus;
  String? debateImageUrl;
  String? debateOwnerNickname;
  String? debateJoinerNickname;

  final int debateOwnerWinningRate;
  final int debateRealtimeParticipants;

  Debate({
    required this.id,
    required this.debateTitle,
    required this.debateStatus,
    this.debateImageUrl,
    this.debateOwnerNickname,
    this.debateJoinerNickname,
    required this.debateOwnerWinningRate,
    required this.debateRealtimeParticipants,
  });

  factory Debate.fromJson(Map<String, dynamic> json) {
    return Debate(
      id: json['id'],
      debateTitle: json['debateTitle'],
      debateStatus: json['debateStatus'],
      debateOwnerNickname: json['debateOwnerNickname'] ?? '',
      debateJoinerNickname: json['debateJoinerNickname'] ?? '',
      debateImageUrl: json['debateImageUrl'] ?? "",
      debateOwnerWinningRate: json['debateOwnerWinningRate'],
      debateRealtimeParticipants: json['debateRealtimeParticipants'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateTitle': debateTitle,
      'debateStatus': debateStatus,
      'debateImageUrl': debateImageUrl,
      "debateOwnerNickname": debateOwnerNickname,
      "debateJoinerNickname": debateJoinerNickname,
      "debateRealtimeParticipants": debateRealtimeParticipants,
      'debateOwnerWinningRate': debateOwnerWinningRate,
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
