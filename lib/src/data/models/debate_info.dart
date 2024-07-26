class DebateInfo {
  const DebateInfo({
    required this.id,
    required this.title,
    required this.myArgument,
    required this.opponentArgument,
    required this.myNick,
    required this.opponentNick,
    required this.turnId,
    required this.category,
    required this.debateState,
    required this.time,
    required this.myTurn,
    required this.opponentTurn,
    required this.content,
    this.imagePath,
  });

  final String id;
  final String title;
  final String myArgument;
  final String opponentArgument;
  final String myNick;
  final String opponentNick;
  final String turnId;
  final String category;
  final String debateState;
  final String content;
  final String time;
  final int myTurn;
  final int opponentTurn;
  final String? imagePath;

  factory DebateInfo.fromMap(String id, Map<String, dynamic> data) {
    return DebateInfo(
      id: id,
      title: data['title'].toString(),
      content: data['content'].toString(),
      category: data['category'].toString(),
      debateState: data['debateState'].toString(),
      myArgument: data['myArgument'].toString(),
      myNick: data['myNick'].toString(),
      opponentArgument: data['opponentArgument'].toString(),
      opponentNick: data['opponentNick'].toString(),
      time: data['timestamp'].toString(),
      turnId: data['turnId'].toString(),
      myTurn: data['myTurn'] ?? 0,
      opponentTurn: data['opponentTurn'] ?? 0,
      imagePath: data['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'myArgument': myArgument,
      'content': content,
      'opponentArgument': opponentArgument,
      'myNick': myNick,
      'opponentNick': opponentNick,
      'turnId': turnId,
      'category': category,
      'debateState': debateState,
      'time': time,
      'myTurn': myTurn,
      'opponentTurn': opponentTurn,
      'imagePath': imagePath,
    };
  }

  DebateInfo copyWith({
    String? id,
    String? title,
    String? myArgument,
    String? opponentArgument,
    String? myNick,
    String? content,
    String? opponentNick,
    String? turnId,
    String? category,
    String? debateState,
    String? time,
    int? myTurn,
    int? opponentTurn,
    String? imagePath,
  }) {
    return DebateInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      myArgument: myArgument ?? this.myArgument,
      content: content ?? this.content,
      opponentArgument: opponentArgument ?? this.opponentArgument,
      myNick: myNick ?? this.myNick,
      opponentNick: opponentNick ?? this.opponentNick,
      turnId: turnId ?? this.turnId,
      category: category ?? this.category,
      debateState: debateState ?? this.debateState,
      time: time ?? this.time,
      myTurn: myTurn ?? this.myTurn,
      opponentTurn: opponentTurn ?? this.opponentTurn,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
