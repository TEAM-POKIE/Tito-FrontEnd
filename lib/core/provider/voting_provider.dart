import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class VotingState {
  final bool isVotingEnabled;

  VotingState({required this.isVotingEnabled});

  VotingState copyWith({bool? isVotingEnabled}) {
    return VotingState(
      isVotingEnabled: isVotingEnabled ?? this.isVotingEnabled,
    );
  }
}

class VotingNotifier extends StateNotifier<VotingState> {
  VotingNotifier() : super(VotingState(isVotingEnabled: false));

  void toggleVoting(bool isEnabled) {
    state = state.copyWith(isVotingEnabled: isEnabled);
  }

  void resetVoting() {
    state = state.copyWith(isVotingEnabled: false);
  }
}

final votingProvider = StateNotifierProvider<VotingNotifier, VotingState>((ref) {
  return VotingNotifier();
});