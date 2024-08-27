class AiWord {
  final String topic;
  final String a;
  final String b;

  AiWord({
    required this.topic,
    required this.a,
    required this.b,
  });

  factory AiWord.fromJson(Map<String, dynamic> json) {
    return AiWord(
      topic: json['topic'] ?? '',
      a: json['a'] ?? '',
      b: json['b'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'a': a,
      'b': b,
    };
  }
}
