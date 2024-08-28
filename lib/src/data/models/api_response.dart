class AiResponse {
  String? contentEdited;
  List<String>? explanation;

  AiResponse({
    this.contentEdited = 'ㅇㅇㅇ', // 기본값 설정
    List<String>? explanation, // 기본값 설정 (null일 경우)
  }) : explanation = explanation ?? ['기본 설명']; // 설명에 대한 기본값 설정

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      contentEdited: json['contentEdited'] ?? 'ㅇㅇㅇ', // null이면 기본값
      explanation: json['explanation'] != null
          ? List<String>.from(json['explanation'])
          : ['기본 설명'], // null이면 기본 설명 리스트
    );
  }
}
