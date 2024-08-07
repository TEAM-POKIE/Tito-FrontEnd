class DebateCreateState {
  final String debateTitle;
  final String debateCategory;
  String debateStatus;

  String debateMakerOpinion;
  String firstChatContent;
  String debateJoinerOpinion;
  String debateImageUrl;

  String debateContent;

  DebateCreateState({
    this.debateTitle = '',
    this.debateCategory = '',
    this.debateStatus = '',
    this.debateMakerOpinion = '',
    this.debateJoinerOpinion = '',
    this.firstChatContent = '',
    this.debateImageUrl = '',
    this.debateContent = '',
  });

  DebateCreateState copyWith({
    String? debateTitle,
    String? debateCategory,
    String? debateStatus,
    String? debateMakerOpinion,
    String? debateJoinerOpinion,
    String? firstChatContent,
    String? debateContent,
    String? debateImageUrl,
  }) {
    return DebateCreateState(
      debateTitle: debateTitle ?? this.debateTitle,
      debateCategory: debateCategory ?? this.debateCategory,
      debateStatus: debateStatus ?? this.debateStatus,
      debateMakerOpinion: debateMakerOpinion ?? this.debateMakerOpinion,
      debateJoinerOpinion: debateJoinerOpinion ?? this.debateJoinerOpinion,
      firstChatContent: firstChatContent ?? this.firstChatContent,
      debateContent: debateContent ?? this.debateContent,
      debateImageUrl: debateImageUrl ?? this.debateImageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debateTitle': debateTitle,
      'debateCategory': debateCategory,
      'debateStatus': debateStatus,
      'debateMakerOpinion': debateMakerOpinion,
      'debateJoinerOpinion': debateJoinerOpinion,
      'firstChatContent': firstChatContent,
      'debateContent': debateContent,
    };
  }
}

class DebateCreateInfo {
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

  DebateCreateInfo({
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

  factory DebateCreateInfo.fromJson(Map<String, dynamic> json) {
    return DebateCreateInfo(
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

enum DebateCategory {
  ROMANCE('연애'),
  POLITICS('정치'),
  ENTERTAINMENT('연예'),
  FREE('자유'),
  SPORTS('스포츠');

  final String displayName;

  const DebateCategory(this.displayName);

  @override
  String toString() => displayName;

  // Enum 값을 문자열로부터 가져오는 메소드
  static DebateCategory fromString(String category) {
    return DebateCategory.values.firstWhere(
      (e) => e.name == category,
      orElse: () => DebateCategory.FREE,
    );
  }
}
