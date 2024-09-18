class SearchData {
  final int searchedDebateId;
  final String searchedDebateTitle;
  final String? searchedDebateStatus;
  final String searchedDebateImageUrl;
  final String searchedDebateOwnerNickname;
  final String searchedDebateJoinerNickname;
  final int searchedDebateRealtimeParticipants;
  final int searchedDebateOwnerWinningRate;

  SearchData(
      {required this.searchedDebateId,
      required this.searchedDebateTitle,
      required this.searchedDebateImageUrl,
      required this.searchedDebateOwnerNickname,
      required this.searchedDebateJoinerNickname,
      required this.searchedDebateRealtimeParticipants,
      required this.searchedDebateOwnerWinningRate,
      this.searchedDebateStatus});

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
        searchedDebateId: json['searchedDebateId'] ?? 0,
        searchedDebateTitle: json['searchedDebateTitle'] ?? '',
        searchedDebateStatus: json['searchedDebateStatus'] ?? '',
        searchedDebateOwnerNickname: json['searchedDebateOwnerNickname'] ?? '',
        searchedDebateJoinerNickname:
            json['searchedDebateJoinerNickname'] ?? '',
        searchedDebateOwnerWinningRate:
            json['searchedDebateOwnerWinningRate'] ?? 0,
        searchedDebateRealtimeParticipants:
            json['searchedDebateRealtimeParticipants'] ?? 0,
        searchedDebateImageUrl: json['searchedDebateImageUrl'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'searchedDebateId': searchedDebateId,
      'nickname': searchedDebateTitle,
      'profilePicture': searchedDebateStatus,
      "searchedDebateImageUrl": searchedDebateImageUrl,
      "searchedDebateOwnerNickname": searchedDebateOwnerNickname,
      "searchedDebateJoinerNickname": searchedDebateJoinerNickname,
      "searchedDebateRealtimeParticipants": searchedDebateRealtimeParticipants,
      "searchedDebateOwnerWinningRate": searchedDebateOwnerWinningRate,
    };
  }
}
