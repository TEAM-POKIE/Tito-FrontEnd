import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/models/debate_info.dart';

// 상태를 관리할 클래스 정의
class DebateInfoNotifier extends StateNotifier<DebateInfo?> {
  DebateInfoNotifier() : super(null);

  void updateDebateInfo(
      {String? id,
      String? title,
      String? myArgument,
      String? myId,
      String? opponentArgument,
      String? opponentId,
      String? debateState,
      String? time,
      String? category}) {
    state = DebateInfo(
      id: id ?? state?.id ?? '',
      title: title ?? state?.title ?? '',
      myArgument: myArgument ?? state?.myArgument ?? '',
      myId: myId ?? state?.myId ?? '',
      opponentId: opponentId ?? state?.opponentId ?? '',
      debateState: debateState ?? state?.debateState ?? '',
      opponentArgument: opponentArgument ?? state?.opponentArgument ?? '',
      category: category ?? state?.category ?? '',
      time: time ?? state?.time ?? '',
    );
  }
}

// StateNotifierProvider 정의
final debateInfoProvider =
    StateNotifierProvider<DebateInfoNotifier, DebateInfo?>((ref) {
  return DebateInfoNotifier();
});
