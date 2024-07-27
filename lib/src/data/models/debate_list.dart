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
