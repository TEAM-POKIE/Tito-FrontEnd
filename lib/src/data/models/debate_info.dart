class DebateInfo {
  final int id;
  final String debateTitle;
  final String debateCategory;
  String debateStatus;
  String debateOwnerNick;
  String debateOwnerPicture;
  String debateJoinerNick;
  String debateJoinerPicture;
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
  Duration remainingTime;
  final String debateImageUrl;
  final String debateContent;
  String contentEdited;
  List<String>? explanation;
  bool isLoading;
  bool isFirstClick;
  bool isVoteEnded;
  String lastUrl;

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
    required this.debateOwnerPicture,
    required this.debateOwnerTurnCount,
    required this.debateJoinerId,
    required this.debateJoinerNick,
    required this.debateJoinerPicture,
    required this.debateJoinerTurnCount,
    required this.canTiming,
    required this.bluePercent,
    required this.remainingTime,
    required this.debateImageUrl,
    required this.debateContent,
    required this.contentEdited,
    required this.explanation,
    required this.isLoading,
    required this.isFirstClick,
    required this.lastUrl,
    required this.isVoteEnded,
  });

  DebateInfo copyWith({
    int? id,
    String? debateTitle,
    String? debateCategory,
    String? debateStatus,
    String? debateOwnerNick,
    String? debateOwnerPicture,
    String? debateJoinerNick,
    String? debateJoinerPicture,
    String? debateMakerOpinion,
    String? debateJoinerOpinion,
    int? debatedTimeLimit,
    int? debateViewCount,
    int? debateCommentCount,
    int? debateRealtimeParticipants,
    int? debateAlarmCount,
    String? createdAt,
    String? updatedAt,
    int? debateOwnerId,
    int? debateOwnerTurnCount,
    int? debateJoinerId,
    int? debateJoinerTurnCount,
    bool? canTiming,
    double? bluePercent,
    Duration? remainingTime,
    String? debateImageUrl,
    String? debateContent,
    String? contentEdited,
    List<String>? explanation,
    bool? isLoading,
    bool? isFirstClick,
    bool? isVoteEnded,
    String? lastUrl,
  }) {
    return DebateInfo(
      id: id ?? this.id,
      debateTitle: debateTitle ?? this.debateTitle,
      debateCategory: debateCategory ?? this.debateCategory,
      debateStatus: debateStatus ?? this.debateStatus,
      debateOwnerNick: debateOwnerNick ?? this.debateOwnerNick,
      debateOwnerPicture: debateOwnerPicture ?? this.debateOwnerPicture,
      debateJoinerNick: debateJoinerNick ?? this.debateJoinerNick,
      debateJoinerPicture: debateJoinerPicture ?? this.debateJoinerPicture,
      debateMakerOpinion: debateMakerOpinion ?? this.debateMakerOpinion,
      debateJoinerOpinion: debateJoinerOpinion ?? this.debateJoinerOpinion,
      debatedTimeLimit: debatedTimeLimit ?? this.debatedTimeLimit,
      debateViewCount: debateViewCount ?? this.debateViewCount,
      debateCommentCount: debateCommentCount ?? this.debateCommentCount,
      debateRealtimeParticipants:
          debateRealtimeParticipants ?? this.debateRealtimeParticipants,
      debateAlarmCount: debateAlarmCount ?? this.debateAlarmCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      debateOwnerId: debateOwnerId ?? this.debateOwnerId,
      debateOwnerTurnCount: debateOwnerTurnCount ?? this.debateOwnerTurnCount,
      debateJoinerId: debateJoinerId ?? this.debateJoinerId,
      debateJoinerTurnCount:
          debateJoinerTurnCount ?? this.debateJoinerTurnCount,
      canTiming: canTiming ?? this.canTiming,
      bluePercent: bluePercent ?? this.bluePercent,
      remainingTime: remainingTime ?? this.remainingTime,
      debateImageUrl: debateImageUrl ?? this.debateImageUrl,
      debateContent: debateContent ?? this.debateContent,
      contentEdited: contentEdited ?? this.contentEdited,
      explanation: explanation ?? this.explanation,
      isLoading: isLoading ?? this.isLoading,
      isFirstClick: isFirstClick ?? this.isFirstClick,
      isVoteEnded: isVoteEnded ?? this.isVoteEnded,
      lastUrl: lastUrl ?? this.lastUrl,
    );
  }

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
      debateOwnerNick: '',
      debateOwnerTurnCount: json['data']['debateOwnerTurnCount'] ?? 0,
      debateJoinerId: json['data']['debateJoinerId'] ?? 0,
      debateJoinerNick: '',
      debateJoinerTurnCount: json['data']['debateJoinerTurnCount'] ?? 0,
      canTiming: true,
      bluePercent: 0.5,
      remainingTime: Duration(minutes: 8),
      debateJoinerPicture: '',
      debateOwnerPicture: '',
      debateImageUrl: json['data']['debateImageUrl'] ?? '',
      debateContent: json['data']['debateContent'] ?? '',
      contentEdited: '',
      explanation: [''],
      isLoading: false,
      isFirstClick: true,
      isVoteEnded: false,
      lastUrl: '',
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
      'debateImageUrl': debateImageUrl,
      'debateContent': debateContent,
      'contentEdited': contentEdited,
    };
  }

  @override
  String toString() {
    return 'Debate{id: $id, debateTitle: $debateTitle, debateCategory: $debateCategory, debateStatus: $debateStatus, debateMakerOpinion: $debateMakerOpinion, debateJoinerOpinion: $debateJoinerOpinion, debatedTimeLimit: $debatedTimeLimit, debateViewCount: $debateViewCount, debateCommentCount: $debateCommentCount, debateRealtimeParticipants: $debateRealtimeParticipants, debateAlarmCount: $debateAlarmCount, createdAt: $createdAt, updatedAt: $updatedAt, debateImageUrl: $debateImageUrl, debateContent: $debateContent}';
  }
}
