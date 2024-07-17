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
  });
  final String id;
  final String myNick;
  final String opponentNick;
  final String title;
  final String myArgument;
  final String opponentArgument;
  final String category;
  final String debateState;
  final String time;
  final String turnId;
  final int myTurn;
  final int opponentTurn;

  factory DebateInfo.fromMap(String id, Map<String, dynamic> data) {
    return DebateInfo(
      id: id,
      title: data['title'].toString(),
      category: data['category'].toString(),
      debateState: data['debateState'].toString(),
      myArgument: data['myArgument'].toString(),
      myNick: data['myNick'].toString(),
      opponentArgument: data['opponentArgument'].toString(),
      opponentNick: data['opponentNick'].toString(),
      time: data['timestamp'].toString(),
      turnId: data['turnId'].toString(),
      myTurn: data['myTurn'],
      opponentTurn: data['opponentTurn'],
    );
  }
}
