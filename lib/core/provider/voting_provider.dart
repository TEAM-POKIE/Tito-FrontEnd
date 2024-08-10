import 'package:hooks_riverpod/hooks_riverpod.dart';

// Riverpod provider 정의
final voteProvider = StateNotifierProvider<VoteNotifier, VoteState>((ref) {
  return VoteNotifier();
});

class VoteNotifier extends StateNotifier<VoteState> {
  VoteNotifier()
      : super(VoteState(
            blueVotes: 0, redVotes: 0, totalVoted: 0, bluePercent: 0.5));

  void updateVotes(int newBlueVotes, int newRedVotes) {
    final newTotalVotes = newBlueVotes + newRedVotes;
    final newBluePercent =
        newTotalVotes == 0 ? 0.0 : newBlueVotes / newTotalVotes.toDouble();

    state = VoteState(
      blueVotes: newBlueVotes,
      redVotes: newRedVotes,
      totalVoted: newTotalVotes,
      bluePercent: newBluePercent,
    );
  }
}

class VoteState {
  final int blueVotes;
  final int redVotes;
  final int totalVoted;
  final double bluePercent;

  VoteState({
    required this.blueVotes,
    required this.redVotes,
    required this.totalVoted,
    required this.bluePercent,
  });
}
