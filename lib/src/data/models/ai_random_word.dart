class AiRandomWord {
  final String word;

  AiRandomWord({
    required this.word,
  });

  factory AiRandomWord.fromJson(Map<String, dynamic> json) {
    return AiRandomWord(
      word: json['word'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': word,
    };
  }
}
