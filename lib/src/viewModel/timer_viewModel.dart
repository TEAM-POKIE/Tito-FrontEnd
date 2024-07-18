import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final Duration remainingTime;

  TimerState({required this.remainingTime});

  TimerState copyWith({Duration? remainingTime}) {
    return TimerState(
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerNotifier()
      : super(TimerState(remainingTime: Duration(minutes: 7, seconds: 20)));

  void startTimer() {
    _timer?.cancel(); // 기존 타이머가 있으면 취소
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.remainingTime.inSeconds > 0) {
        state = state.copyWith(
          remainingTime: state.remainingTime - Duration(seconds: 1),
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    state = TimerState(remainingTime: Duration(minutes: 7, seconds: 20));
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
