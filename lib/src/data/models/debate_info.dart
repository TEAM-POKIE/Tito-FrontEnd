class DebateInfo {
  final int id;
  final String debateTitle;
  final String debateCategory;
  String debateStatus;
  String debateOwnerNick;
  String debateJoinerNick;
  final String debateMakerOpinion;
  final String debateJoinerOpinion;
  int debatedTimeLimit;
  final int debateViewCount;
  final int debateCommentCount;
  final int debateRealtimeParticipants;
  final int debateAlarmCount;
  final String createdAt;
  final String updatedAt;
  int debateOwnerId;
  int debateOwnerTurnCount;
  int debateJoinerId;
  int debateJoinerTurnCount;
  bool canTiming;
  double bluePercent;

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
    required this.debateOwnerId,
    required this.debateOwnerNick,
    required this.debateOwnerTurnCount,
    required this.debateJoinerId,
    required this.debateJoinerNick,
    required this.debateJoinerTurnCount,
    required this.canTiming,
    required this.bluePercent,
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
      debateOwnerId: json['data']['debateOwnerId'] ?? 0,
      debateOwnerNick: '티토',
      debateOwnerTurnCount: json['data']['debateOwnerTurnCount'] ?? 0,
      debateJoinerId: json['data']['debateJoinerId'] ?? 0,
      debateJoinerNick: '티토',
      debateJoinerTurnCount: json['data']['debateJoinerTurnCount'] ?? 0,
      canTiming: true,
      bluePercent: 0.5,
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
      "debateOwnerId": debateOwnerId,
      "debateOwnerTurnCount": debateOwnerTurnCount,
      "debateJoinerId": debateOwnerTurnCount,
      "debateJoinerNick": debateJoinerNick,
      "debateOwnerNick": debateOwnerNick,
      "debateJoinerTurnCount": debateOwnerTurnCount,
      "canTiming": true,
    };
  }

  @override
  String toString() {
    return 'Debate{id: $id, debateTitle: $debateTitle, debateCategory: $debateCategory, debateStatus: $debateStatus, debateMakerOpinion: $debateMakerOpinion, debateJoinerOpinion: $debateJoinerOpinion, debatedTimeLimit: $debatedTimeLimit, debateViewCount: $debateViewCount, debateCommentCount: $debateCommentCount, debateRealtimeParticipants: $debateRealtimeParticipants, debateAlarmCount: $debateAlarmCount, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
