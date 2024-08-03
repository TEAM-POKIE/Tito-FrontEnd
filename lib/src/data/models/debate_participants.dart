class DebateParticipants {
  final int id;
  final int debateId;
  final int userId;
  final bool debateOwner;
  final bool debateWinOrLose;
  final int turnCount;
  final DateTime turnStartTime;
  final int noResponseCount;
  final int timingBellCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  DebateParticipants({
    required this.id,
    required this.debateId,
    required this.userId,
    required this.debateOwner,
    required this.debateWinOrLose,
    required this.turnCount,
    required this.turnStartTime,
    required this.noResponseCount,
    required this.timingBellCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DebateParticipants.fromJson(Map<String, dynamic> json) {
    return DebateParticipants(
      id: json['id'] ?? 0,
      debateId: json['debateId'] ?? 0,
      userId: json['userId'] ?? 0,
      debateOwner: json['debateOwner'] ?? false,
      debateWinOrLose: json['debateWinOrLose'],
      turnCount: json['turnCount'] ?? 0,
      turnStartTime: DateTime.parse(json['turnStartTime']),
      noResponseCount: json['noResponseCount'] ?? 0,
      timingBellCount: json['timingBellCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateId': debateId,
      'userId': userId,
      'debateOwner': debateOwner,
      'debateWinOrLose': debateWinOrLose,
      'turnCount': turnCount,
      'turnStartTime': turnStartTime.toIso8601String(),
      'noResponseCount': noResponseCount,
      'timingBellCount': timingBellCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
