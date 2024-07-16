import 'package:flutter_riverpod/flutter_riverpod.dart';

// 두 개의 숫자를 관리하는 TurnState 클래스
class TurnState {
  final int myTurn;
  final int opponentTurn;

  TurnState({this.myTurn = 0, this.opponentTurn = 0});

  // 복사본을 만들고 값을 업데이트하는 copyWith 메서드
  TurnState copyWith({int? myTurn, int? opponentTurn}) {
    return TurnState(
      myTurn: myTurn ?? this.myTurn,
      opponentTurn: opponentTurn ?? this.opponentTurn,
    );
  }
}

// TurnState를 관리하는 StateNotifier
class TurnNotifier extends StateNotifier<TurnState> {
  TurnNotifier() : super(TurnState());

  void incrementMyTurn() {
    state = state.copyWith(myTurn: state.myTurn + 1);
  }

  void incrementOpponentTurn() {
    state = state.copyWith(opponentTurn: state.opponentTurn + 1);
  }

  void resetTurn() {
    state = state.copyWith(myTurn: 0);
    state = state.copyWith(opponentTurn: 0);
  }
}

// TurnNotifier를 관리하는 StateNotifierProvider
final turnProvider = StateNotifierProvider<TurnNotifier, TurnState>((ref) {
  return TurnNotifier();
});
