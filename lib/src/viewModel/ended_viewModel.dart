import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

import 'package:tito_app/src/data/models/ended_chat.dart';

class EndedViewModel extends StateNotifier<EndedChatInfo?> {
  final Ref ref;

  EndedViewModel(this.ref) : super(null);

  Future<List<EndedChatInfo>> getChat(int debateId) async {
    try {
      final response = await ApiService(DioClient.dio).getDebateChat(debateId);
      print(response);
      return response; // List<EndedChatInfo> 반환
    } catch (e) {
      print('Failed to load chat: $e');
      return []; // 에러가 발생한 경우 빈 리스트 반환
    }
  }
}
