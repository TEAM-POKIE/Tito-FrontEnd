class DebateInfo {
  const DebateInfo({
    required this.id,
    required this.title,
    required this.myArgument,
    required this.opponentArgument,
    required this.myId,
    required this.opponentId,
    required this.category,
    required this.debateState,
    required this.time,
  });
  final String id;
  final String myId;
  final String opponentId;
  final String title;
  final String myArgument;
  final String opponentArgument;
  final String category;
  final String debateState;
  final String time;
  factory DebateInfo.fromMap(String id, Map<String, dynamic> data) {
    return DebateInfo(
      id: id,
      title: data['title'].toString(),
      category: data['category'].toString(),
      debateState: data['debateState'].toString(),
      myArgument: data['myArgument'].toString(),
      myId: data['myId'].toString(),
      opponentArgument: data['opponentArgument'].toString(),
      opponentId: data['opponentId'].toString(),
      time: data['timestamp'].toString(),
    );
  }
}
