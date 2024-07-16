class User {
  final String id;

  User({required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Message {
  final String id;
  final User author;
  final int createdAt;
  final String text;

  Message({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.text,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      author: User.fromJson(json['author']),
      createdAt: json['createdAt'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'createdAt': createdAt,
      'text': text,
    };
  }
}

class TextMessage extends Message {
  TextMessage({
    required String id,
    required User author,
    required int createdAt,
    required String text,
  }) : super(id: id, author: author, createdAt: createdAt, text: text);

  factory TextMessage.fromJson(Map<String, dynamic> json) {
    return TextMessage(
      id: json['id'] as String,
      author: User.fromJson(json['author']),
      createdAt: json['createdAt'] as int,
      text: json['text'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'createdAt': createdAt,
      'text': text,
    };
  }
}
