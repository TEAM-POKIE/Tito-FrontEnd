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
      id: json['data']['id'] ?? 0, // null인 경우 0으로 기본값 설정
      debateTitle: json['data']['debateTitle'] ?? '', // 문자열도 기본값 설정
      debateStatus: json['data']['debateStatus'] ?? '',
      debateMakerOpinion: json['data']['debateMakerOpinion'] ?? '',
      debateJoinerOpinion: json['data']['debateJoinerOpinion'] ?? '',
      debateImageUrl: json['data']['debateImageUrl'],
      debateFireCount: json['data']['debateFireCount'] ?? 1,
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
}
