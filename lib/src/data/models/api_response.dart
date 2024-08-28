class AiResponse {
  final String? contentEdited;
  final List<String> explanation;

  AiResponse({
    required this.contentEdited,
    required this.explanation,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      contentEdited: json['contentEdited'],
      explanation: List<String>.from(json['explanation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentEdited': contentEdited,
      'explanation': explanation,
    };
  }
}
