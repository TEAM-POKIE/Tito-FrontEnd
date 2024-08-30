import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';
import 'package:tito_app/src/viewModel/debate_create_viewModel.dart';

final debateCreateProvider =
    StateNotifierProvider<DebateCreateViewModel, DebateCreateState>(
        (ref) => DebateCreateViewModel(ref));

class ProgressNotifier extends StateNotifier<double> {
  ProgressNotifier() : super(0.33); // progress 0.33부터 시작

  void incrementProgress() {
    if (state < 1.0) {
      if (state == 0.33) {
        state = 0.66;
      } else if (state == 0.66) {
        state = 1.0;
      }
      // 만약 state가 1.0이면 더 이상 증가하지 않음.
    }
  }

  void decreaseProgress() {
    if (state <= 1.0) {
      if (state == 1) {
        state = 0.66;
      } else if (state == 0.66) {
        state = 0.33;
      }
      // 만약 state가 1.0이면 더 이상 증가하지 않음.
    }
  }

  void resetProgress() {
    state = 0.33;
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, double>((ref) {
  return ProgressNotifier();
});
