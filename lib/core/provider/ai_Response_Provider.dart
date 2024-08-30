import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/api_response.dart';

class AiResponseNotifier extends StateNotifier<AiResponse?> {
  AiResponseNotifier() : super(null);

  // AiResponse 상태를 업데이트하는 메서드
  void setAiResponse(AiResponse aiResponse) {
    state = aiResponse;
  }

  // AiResponse 상태를 초기화하는 메서드
  void clearAiResponse() {
    state = null;
  }
}

final aiResponseProvider =
    StateNotifierProvider<AiResponseNotifier, AiResponse?>((ref) {
  return AiResponseNotifier();
});
