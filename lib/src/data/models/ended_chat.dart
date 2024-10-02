class EndedChatInfo {
  final int id;
  final String debateTitle;
  final String debateCategory;
  String debateStatus;
  final String debateMakerOpinion;
  final String debateJoinerOpinion;
  final String debateContent;
  final String debateImageUrl;
  final int debateOwnerId;
  final String debateOwnerImageUrl;
  final String debateOwnerName;
  final bool debateOwnerWinOrLose;
  final int debateJoinerId;
  final String debateJoinerImageUrl;
  final String debateJoinerName;
  final bool debateJoinerWinOrLose;
  final int ownerVoteRate;
  final int joinerVoteRate;
  final String createdAt;
  final String updatedAt;

  EndedChatInfo({
    required this.id,
    required this.debateTitle,
    required this.debateCategory,
    required this.debateStatus,
    required this.debateMakerOpinion,
    required this.debateJoinerOpinion,
    required this.debateContent,
    required this.debateImageUrl,
    required this.debateOwnerId,
    required this.debateOwnerImageUrl,
    required this.debateOwnerName,
    required this.debateOwnerWinOrLose,
    required this.debateJoinerId,
    required this.debateJoinerImageUrl,
    required this.debateJoinerName,
    required this.debateJoinerWinOrLose,
    required this.ownerVoteRate,
    required this.joinerVoteRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EndedChatInfo.fromJson(Map<String, dynamic> json) {
    return EndedChatInfo(
      id: json['data']['id'] ?? 0,
      debateTitle: json['data']['debateTitle'] ?? '',
      debateCategory: json['data']['debateCategory'] ?? '',
      debateStatus: json['data']['debateStatus'] ?? '',
      debateMakerOpinion: json['data']['debateMakerOpinion'] ?? '',
      debateJoinerOpinion: json['data']['debateJoinerOpinion'] ?? '',
      debateContent: json['data']['debateContent'] ?? '',
      debateImageUrl: json['data']['debateImageUrl'] ?? '',
      debateOwnerId: json['data']['debateOwnerId'] ?? 0,
      debateOwnerImageUrl: json['data']['debateOwnerImageUrl'] ?? '',
      debateOwnerName: json['data']['debateOwnerName'] ?? '',
      debateOwnerWinOrLose: json['data']['debateOwnerWinOrLose'] ?? false,
      debateJoinerId: json['data']['debateJoinerId'] ?? 0,
      debateJoinerImageUrl: json['data']['debateJoinerImageUrl'] ?? '',
      debateJoinerName: json['data']['debateJoinerName'] ?? '',
      debateJoinerWinOrLose: json['data']['debateJoinerWinOrLose'] ?? false,
      ownerVoteRate: json['data']['ownerVoteRate'] ?? 0,
      joinerVoteRate: json['data']['joinerVoteRate'] ?? 0,
      createdAt: json['data']['createdAt'] ?? '',
      updatedAt: json['data']['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debateTitle': debateTitle,
      'debateCategory': debateCategory,
      'debateStatus': debateStatus,
      'debateMakerOpinion': debateMakerOpinion,
      'debateJoinerOpinion': debateJoinerOpinion,
      'debateContent': debateContent,
      'debateImageUrl': debateImageUrl,
      'debateOwnerId': debateOwnerId,
      'debateOwnerImageUrl': debateOwnerImageUrl,
      'debateOwnerName': debateOwnerName,
      'debateOwnerWinOrLose': debateOwnerWinOrLose,
      'debateJoinerId': debateJoinerId,
      'debateJoinerImageUrl': debateJoinerImageUrl,
      'debateJoinerName': debateJoinerName,
      'debateJoinerWinOrLose': debateJoinerWinOrLose,
      'ownerVoteRate': ownerVoteRate,
      'joinerVoteRate': joinerVoteRate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'Debate{id: $id, debateTitle: $debateTitle, debateCategory: $debateCategory, debateStatus: $debateStatus, debateMakerOpinion: $debateMakerOpinion, debateJoinerOpinion: $debateJoinerOpinion, debateContent: $debateContent, debateImageUrl: $debateImageUrl, debateOwnerId: $debateOwnerId, debateOwnerName: $debateOwnerName, debateJoinerName: $debateJoinerName, ownerVoteRate: $ownerVoteRate, joinerVoteRate: $joinerVoteRate, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
