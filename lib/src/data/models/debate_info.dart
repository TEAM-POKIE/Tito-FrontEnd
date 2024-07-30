class DebateInfo {
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

  DebateInfo({
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

  factory DebateInfo.fromJson(Map<String, dynamic> json) {
    return DebateInfo(
      id: json['data']['id'] ?? 0,
      debateTitle: json['data']['debateTitle'] ?? '',
      debateCategory: json['data']['debateCategory'] ?? '',
      debateStatus: json['data']['debateStatus'] ?? '',
      debateMakerOpinion: json['data']['debateMakerOpinion'] ?? '',
      debateJoinerOpinion: json['data']['debateJoinerOpinion'] ?? '',
      debatedTimeLimit: json['data']['debatedTimeLimit'] ?? 0,
      debateViewCount: json['data']['debateViewCount'] ?? 0,
      debateCommentCount: json['data']['debateCommentCount'] ?? 0,
      debateRealtimeParticipants:
          json['data']['debateRealtimeParticipants'] ?? 0,
      debateAlarmCount: json['data']['debateAlarmCount'] ?? 0,
      createdAt: json['data']['createdAt'] ?? '',
      updatedAt: json['data']['updatedAt'] ?? '',
    );
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

  @override
  String toString() {
    return 'Debate{id: $id, debateTitle: $debateTitle, debateCategory: $debateCategory, debateStatus: $debateStatus, debateMakerOpinion: $debateMakerOpinion, debateJoinerOpinion: $debateJoinerOpinion, debatedTimeLimit: $debatedTimeLimit, debateViewCount: $debateViewCount, debateCommentCount: $debateCommentCount, debateRealtimeParticipants: $debateRealtimeParticipants, debateAlarmCount: $debateAlarmCount, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
