class DebateCreateState {
  final String debateTitle;
  final String debateCategory;
  String debateStatus;

  String debateMakerOpinion;
  String firstChatContent;
  String debateJoinerOpinion;

  DebateCreateState({
    this.debateTitle = '',
    this.debateCategory = '',
    this.debateStatus = '',
    this.debateMakerOpinion = '',
    this.debateJoinerOpinion = '',
    this.firstChatContent = '',
  });

  DebateCreateState copyWith({
    String? debateTitle,
    String? debateCategory,
    String? debateStatus,
    String? debateMakerOpinion,
    String? debateJoinerOpinion,
    String? firstChatContent,
  }) {
    return DebateCreateState(
      debateTitle: debateTitle ?? this.debateTitle,
      debateCategory: debateCategory ?? this.debateCategory,
      debateStatus: debateStatus ?? this.debateStatus,
      debateMakerOpinion: debateMakerOpinion ?? this.debateMakerOpinion,
      debateJoinerOpinion: debateJoinerOpinion ?? this.debateJoinerOpinion,
      firstChatContent: firstChatContent ?? this.firstChatContent,
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
    };
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
