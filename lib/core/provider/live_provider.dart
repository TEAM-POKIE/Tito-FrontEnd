import 'package:hooks_riverpod/hooks_riverpod.dart';

final messagesProvider =
    StateNotifierProvider<MessagesNotifier, List<Map<String, dynamic>>>((ref) {
  return MessagesNotifier();
});

class MessagesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  MessagesNotifier() : super([]);

  // 메시지 추가 함수
  void addMessage(Map<String, dynamic> message) {
    state = [...state, message];
  }

  // 메시지 리스트 초기화 또는 다른 조작 함수도 추가 가능
  void clearMessages() {
    state = [];
  }
}
