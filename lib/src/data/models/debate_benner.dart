class DebateBenner {
  final int id;
  final String debateTitle;
  final String debateStatus;
  final String debateMakerOpinion;
  final String debateJoinerOpinion;
  final String? debateImageUrl;

  DebateBenner({
    required this.id,
    required this.debateTitle,
    required this.debateStatus,
    required this.debateMakerOpinion,
    required this.debateJoinerOpinion,
    this.debateImageUrl,
  });

  factory DebateBenner.fromJson(Map<String, dynamic> json) {
    return DebateBenner(
      id: json['id'],
      debateTitle: json['debateTitle'],
      debateStatus: json['debateStatus'],
      debateMakerOpinion: json['debateMakerOpinion'],
      debateJoinerOpinion: json['debateJoinerOpinion'],
      debateImageUrl: json['debateImageUrl'],
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
    };
  }

  @override
  String toString() {
    return 'DebateBenner(id: $id, debateTitle: $debateTitle, debateStatus: $debateStatus, '
        'debateMakerOpinion: $debateMakerOpinion, debateJoinerOpinion: $debateJoinerOpinion, '
        'debateImageUrl: $debateImageUrl)';
  }
}
