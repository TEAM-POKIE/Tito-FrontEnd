class FreeScreenItem {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  int likes;

  FreeScreenItem({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.likes = 0,
  });

  factory FreeScreenItem.fromJson(Map<String, dynamic> json) {
    return FreeScreenItem(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
