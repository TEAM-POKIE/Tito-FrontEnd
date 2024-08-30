import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';

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
  final int debatedTimeLimit;
  static const String _prefsKeyRemainingTime = "remainingTime";
  static const String _prefsKeyStartTime = "startTime";
  final StateNotifierProviderRef ref;

  TimerNotifier({required this.ref, this.debatedTimeLimit = 8})
      : super(TimerState(remainingTime: Duration(minutes: debatedTimeLimit))) {
    _loadTimerState();
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final int? seconds = prefs.getInt(_prefsKeyRemainingTime);
    final int? startTimeMillis = prefs.getInt(_prefsKeyStartTime);

    if (seconds != null && startTimeMillis != null) {
      final startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
      final now = DateTime.now();
      final elapsed = now.difference(startTime).inSeconds;
      final newRemainingTime = Duration(seconds: seconds - elapsed);

      if (newRemainingTime > Duration.zero) {
        state = state.copyWith(remainingTime: newRemainingTime);
        _updateChatState(newRemainingTime);
        startTimer(); // 타이머 시작
      } else {
        _clearSavedTimerState();
      }
    }
  }

  void _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKeyRemainingTime, state.remainingTime.inSeconds);
    await prefs.setInt(
        _prefsKeyStartTime, DateTime.now().millisecondsSinceEpoch);
  }

  void startTimer({DateTime? startTime}) {
    if (_timer != null && _timer!.isActive) {
      return;
    }

    final DateTime now = DateTime.now();
    if (startTime != null) {
      final int elapsed = now.difference(startTime).inSeconds;
      final int remaining = debatedTimeLimit * 60 - elapsed;
      if (remaining > 0) {
        state = state.copyWith(remainingTime: Duration(seconds: remaining));
      } else {
        state = TimerState(remainingTime: Duration.zero);
        _clearSavedTimerState();
        return;
      }
    }

    _saveTimerState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.remainingTime.inSeconds > 0) {
        final newRemainingTime = state.remainingTime - Duration(seconds: 1);
        state = state.copyWith(remainingTime: newRemainingTime);
        _updateChatState(newRemainingTime);
        // 타이머 상태가 저장될 때마다 SharedPreferences를 업데이트하지 않도록 수정
        if (newRemainingTime.inSeconds % 10 == 0) {
          _saveTimerState(); // 주기적으로만 저장
        }
      } else {
        _timer?.cancel();
        _clearSavedTimerState();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetTimer({DateTime? startTime}) {
    stopTimer();

    if (startTime != null) {
      final DateTime now = DateTime.now();
      final int elapsed = now.difference(startTime).inSeconds;
      final int remaining = debatedTimeLimit * 60 - elapsed;

      if (remaining > 0) {
        state = TimerState(remainingTime: Duration(seconds: remaining));
      } else {
        state = TimerState(remainingTime: Duration.zero);
        _clearSavedTimerState();
        return;
      }
    } else {
      state = TimerState(remainingTime: Duration(minutes: debatedTimeLimit));
    }

    _updateChatState(state.remainingTime);
    startTimer();
  }

  void _updateChatState(Duration newRemainingTime) {
    final chatNotifier = ref.read(chatInfoProvider.notifier);
    chatNotifier.updateRemainTimer(newRemainingTime);
  }

  Future<void> _clearSavedTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyRemainingTime);
    await prefs.remove(_prefsKeyStartTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
