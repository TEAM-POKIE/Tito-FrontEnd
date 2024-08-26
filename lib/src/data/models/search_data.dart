class SearchData {
  final int searchedDebateId;
  final String searchedDebateTitle;
  final String? searchedDebateStatus;
  final String searchedDebateImageUrl;
  final int searchedDebateRealtimeParticipants;
  final int searchedDebateOwnerWinningRate;

  SearchData(
      {required this.searchedDebateId,
      required this.searchedDebateTitle,
      required this.searchedDebateImageUrl,
      required this.searchedDebateRealtimeParticipants,
      required this.searchedDebateOwnerWinningRate,
      this.searchedDebateStatus});

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
        searchedDebateId: json['searchedDebateId'] ?? 0,
        searchedDebateTitle: json['searchedDebateTitle'] ?? '',
        searchedDebateStatus: json['searchedDebateStatus'] ?? '',
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
      "searchedDebateRealtimeParticipants": searchedDebateRealtimeParticipants,
      "searchedDebateOwnerWinningRate": searchedDebateOwnerWinningRate,
    };
  }
}
