import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/debate_info.dart';

// 상태를 관리할 클래스 정의
class DebateInfoNotifier extends StateNotifier<DebateInfo?> {
  DebateInfoNotifier() : super(null);

  void updateDebateInfo(
      {String? id,
      String? title,
      String? turnId,
      String? myArgument,
      String? myNick,
      String? opponentArgument,
      String? opponentNick,
      String? debateState,
      String? time,
      bool? visibleDebate,
      String? category}) {
    state = DebateInfo(
      id: id ?? state?.id ?? '',
      title: title ?? state?.title ?? '',
      myArgument: myArgument ?? state?.myArgument ?? '',
      myNick: myNick ?? state?.myNick ?? '',
      turnId: turnId ?? state?.turnId ?? '',
      opponentNick: opponentNick ?? state?.opponentNick ?? '',
      debateState: debateState ?? state?.debateState ?? '',
      opponentArgument: opponentArgument ?? state?.opponentArgument ?? '',
      category: category ?? state?.category ?? '',
      time: time ?? state?.time ?? '',
      visibleDebate: visibleDebate ?? state?.visibleDebate ?? false,
    );
  }
}

// StateNotifierProvider 정의
final debateInfoProvider =
    StateNotifierProvider<DebateInfoNotifier, DebateInfo?>((ref) {
  return DebateInfoNotifier();
});
