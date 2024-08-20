class DataItem {
  final String topic;
  final String a;
  final String b;

  DataItem({
    required this.topic,
    required this.a,
    required this.b,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
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

class AiWord {
  final int code;
  final String message;
  final List<DataItem> data;

  AiWord({
    required this.code,
    required this.message,
    required this.data,
  });

  factory AiWord.fromJson(Map<String, dynamic> json) {
    return AiWord(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => DataItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
