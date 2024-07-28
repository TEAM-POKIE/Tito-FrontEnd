import 'package:hooks_riverpod/hooks_riverpod.dart';

// Riverpod provider 정의
final voteProvider = StateNotifierProvider<VoteNotifier, VoteState>((ref) {
  return VoteNotifier();
});

class VoteState {
  final int blueVotes;
  final int redVotes;

  VoteState({required this.blueVotes, required this.redVotes});
}

class VoteNotifier extends StateNotifier<VoteState> {
  VoteNotifier() : super(VoteState(blueVotes: 0, redVotes: 0));

  void voteBlue() {
    state = VoteState(blueVotes: state.blueVotes + 1, redVotes: state.redVotes);
  }

  void voteRed() {
    state = VoteState(blueVotes: state.blueVotes, redVotes: state.redVotes + 1);
  }
}
