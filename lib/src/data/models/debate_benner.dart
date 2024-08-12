class DebateBenner {
  final int id;
  final String debateTitle;
  final String debateStatus;
  final String debateMakerOpinion;
  final String debateJoinerOpinion;

  DebateBenner(
      {required this.id,
      required this.debateTitle,
      required this.debateStatus,
      required this.debateMakerOpinion,
      required this.debateJoinerOpinion});

  factory DebateBenner.fromJson(Map<String, dynamic> json) {
    return DebateBenner(
        id: json['id'] ?? 0,
        debateTitle: json['debateTitle'] ?? '',
        debateStatus: json['debateStatus'] ?? '',
        debateMakerOpinion: json['debateMakerOpinion'] ?? '',
        debateJoinerOpinion: json['debateJoinerOpinion'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateTitle': debateTitle,
      'debateStatus': debateStatus,
      'debateMakerOpinion': debateMakerOpinion,
      'debateJoinerOpinion': debateJoinerOpinion,
    };
  }
}
