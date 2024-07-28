class DebateCreateState {
  final String debateTitle;
  final String debateCategory;

  String debateMakerOpinion;
  String firstChatContent;
  String debateJoinerOpinion;
  String debateStatus;

  DebateCreateState({
    this.debateTitle = '',
    this.debateCategory = '',
    this.debateMakerOpinion = '',
    this.firstChatContent = '',
    this.debateJoinerOpinion = '',
    this.debateStatus = '',
  });

  DebateCreateState copyWith({
    String? debateTitle,
    String? debateCategory,
    String? debateMakerOpinion,
    String? firstChatContent,
    String? debateJoinerOpinion,
    String? debateStatus,
  }) {
    return DebateCreateState(
      debateTitle: debateTitle ?? this.debateTitle,
      debateCategory: debateCategory ?? this.debateCategory,
      debateMakerOpinion: debateMakerOpinion ?? this.debateMakerOpinion,
      firstChatContent: firstChatContent ?? this.firstChatContent,
      debateJoinerOpinion: debateJoinerOpinion ?? this.debateJoinerOpinion,
      debateStatus: debateStatus ?? this.debateStatus,
    );
  }
}
