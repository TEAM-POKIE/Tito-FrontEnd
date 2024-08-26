class DebateHotdebate {
  final int id;
  final String debateTitle;
  final String debateStatus;
  final String debateMakerOpinion;
  final String debateJoinerOpinion;
  final String? debateImageUrl;
  final int debateFireCount;

  DebateHotdebate({
    required this.id,
    required this.debateTitle,
    required this.debateStatus,
    required this.debateMakerOpinion,
    required this.debateJoinerOpinion,
    this.debateImageUrl,
    required this.debateFireCount,
  });

  factory DebateHotdebate.fromJson(Map<String, dynamic> json) {
    return DebateHotdebate(
      id: json['id'] ?? 0,
      debateTitle: json['debateTitle'] ?? '',
      debateStatus: json['debateStatus'] ?? '',
      debateMakerOpinion: json['debateMakerOpinion'] ?? '',
      debateJoinerOpinion: json['debateJoinerOpinion'] ?? '',
      debateImageUrl: json['debateImageUrl'],
      debateFireCount: json['debateFireCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateTitle': debateTitle,
      'debateStatus': debateStatus,
      'debateMakerOpinion': debateMakerOpinion,
      'debateJoinerOpinion': debateJoinerOpinion,
      'debateImageUrl': debateImageUrl,
      'debateFireCount': debateFireCount
    };
  }

  @override
  String toString() {
    return 'DebateHotdebate{id: $id, title: $debateTitle, status: $debateStatus, makerOpinion: $debateMakerOpinion, joinerOpinion: $debateJoinerOpinion, fireCount: $debateFireCount}';
  }
}
