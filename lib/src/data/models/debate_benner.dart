class DebateBenner {
  final int id;
  final String debateTitle;
  final String debateStatus;
  final String debateMakerOpinion;
  final String debateJoinerOpinioin;

  DebateBenner(
      {required this.id,
      required this.debateTitle,
      required this.debateStatus,
      required this.debateMakerOpinion,
      required this.debateJoinerOpinioin});

  factory DebateBenner.fromJson(Map<String, dynamic> json) {
    return DebateBenner(
        id: json['data']['id'] ?? 0,
        debateTitle: json['data']['debateTitle'] ?? '',
        debateStatus: json['data']['debateStatus'] ?? '',
        debateMakerOpinion: json['data']['debateMakerOpinion'] ?? '',
        debateJoinerOpinioin: json['data']['debateJoinerOpinioin'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateTitle': debateTitle,
      'debateStatus' : debateStatus,
      'debateMakerOpinion': debateMakerOpinion,
      'debateJoinerOpinion': debateJoinerOpinioin,
    };
  }
}
