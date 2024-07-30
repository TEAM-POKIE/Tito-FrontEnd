class Debate {
  final int id;
  final String debateTitle;
  final String debateCategory;
  final String debateStatus;
  final String debateMakerOpinion;
  final String debateJoinerOpinion;
  final int debatedTimeLimit;
  final int debateViewCount;
  final int debateCommentCount;
  final int debateRealtimeParticipants;
  final int debateAlarmCount;
  final String createdAt;
  final String updatedAt;

  Debate({
    required this.id,
    required this.debateTitle,
    required this.debateCategory,
    required this.debateStatus,
    required this.debateMakerOpinion,
    required this.debateJoinerOpinion,
    required this.debatedTimeLimit,
    required this.debateViewCount,
    required this.debateCommentCount,
    required this.debateRealtimeParticipants,
    required this.debateAlarmCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Debate.fromJson(Map<String, dynamic> json) {
    return Debate(
        id: json['id'],
        debateTitle: json['debateTitle'],
        debateCategory: json['debateCategory'],
        debateStatus: json['debateStatus'],
        debateMakerOpinion: json['debateMakerOpinion'],
        debateJoinerOpinion: json['debateJoinerOpinion'],
        debatedTimeLimit: json['debatedTimeLimit'],
        debateViewCount: json['debateViewCount'],
        debateCommentCount: json['debateCommentCount'],
        debateRealtimeParticipants: json['debateRealtimeParticipants'],
        debateAlarmCount: json['debateAlarmCount'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateTitle': debateTitle,
      'debateCategory': debateCategory,
      'debateStatus': debateStatus,
      'debateMakerOpinion': debateMakerOpinion,
      'debateJoinerOpinion': debateJoinerOpinion,
      'debatedTimeLimit': debatedTimeLimit,
      'debateViewCount': debateViewCount,
      'debateCommentCount': debateCommentCount,
      'debateRealtimeParticipants': debateRealtimeParticipants,
      'debateAlarmCount': debateAlarmCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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
