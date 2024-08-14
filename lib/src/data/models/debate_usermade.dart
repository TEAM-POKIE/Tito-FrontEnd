class DebateUsermade {
  final int id;
  final String debateTitle;
  final String debateCategory;
  final String debateStatus;
  final String debateMakerOpinion;
  final String debateJoinerOpinion;
  final String debateImageUrl;
  final int debatedTimeLimit;
  final int debateViewCount;
  final int debateCommentCount;
  final int debateRealtimeParticipants;
  final int debateAlarmCount;
  final String createdAt;
  final bool isWinOrLoose;
  final String updatedAt;

  DebateUsermade({
    required this.id,
    required this.debateCategory,
    required this.debateTitle,
    required this.debateStatus,
    required this.debateMakerOpinion,
    required this.debateJoinerOpinion,
    required this.debateImageUrl,
    required this.debatedTimeLimit,
    required this.debateViewCount,
    required this.debateCommentCount,
    required this.debateRealtimeParticipants,
    required this.debateAlarmCount,
    required this.isWinOrLoose,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DebateUsermade.fromJson(Map<String, dynamic> json) {
    return DebateUsermade(
        id: json['id'] ?? 0,
        debateTitle: json['debateTitle'] ?? '',
        debateCategory: json['debateCategory'] ?? '',
        debateStatus: json['debateStatus'] ?? '',
        debateMakerOpinion: json['debateMakerOpinion'] ?? '',
        debateJoinerOpinion: json['debateJoinerOpinion'] ?? '',
        debateImageUrl: json['debateImageUrl']??'',
        debatedTimeLimit: json['debatedTimeLimit'] ?? 0,
        debateViewCount: json['debateViewCount'] ?? 0,
        debateCommentCount: json['debateCommentCount'] ?? 0,
        debateRealtimeParticipants: json['debateRealtimeParticipants'] ?? 0,
        debateAlarmCount: json['debateAlarmCount'] ?? 0,
        createdAt: json['createdAt'] ?? '',
        isWinOrLoose: json['isWinOrLoose'] ?? false,
        updatedAt: json['updatedAt'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateCategory': debateCategory,
      'debateStatus': debateStatus,
      'debateMakerOpinion': debateMakerOpinion,
      'debateJoinerOpinion': debateJoinerOpinion,
      'debateImageUrl': debateImageUrl,
      'debatedTimeLimit': debatedTimeLimit,
      'debateViewCount': debateViewCount,
      'debateCommentCount': debateCommentCount,
      'debateRealtimeParticipants': debateRealtimeParticipants,
      'debateAlarmCount': debateAlarmCount,
      'isWinOrLoose': isWinOrLoose,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
