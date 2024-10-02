import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

import 'package:tito_app/src/data/models/ended_chat.dart';
import 'package:tito_app/src/data/models/ended_chatList.dart';

class EndedViewModel extends StateNotifier<EndedChatInfo?> {
  final Ref ref;

  EndedViewModel(this.ref) : super(null);

  Future<List<EndedChatingList>> getChat(int debateId) async {
    try {
      // API 호출
      final response = await ApiService(DioClient.dio).getDebateChat(debateId);

      // 응답을 Map<String, dynamic>으로 디코딩
      final Map<String, dynamic> decodedResponse = json.decode(response);

      // 'data' 필드에서 List<dynamic> 추출
      final List<dynamic> dataList = decodedResponse['data'] as List<dynamic>;

      // 데이터를 EndedChatingList 객체 리스트로 변환
      final List<EndedChatingList> messages = dataList
          .map(
              (item) => EndedChatingList.fromJson(item as Map<String, dynamic>))
          .toList();

      // 제대로 된 리스트 반환
      return messages;
    } catch (e) {
      print('Failed to load chat: $e');
      return [];
    }
  }

  Future<void> fetchEndedDebateInfo(int id) async {
    try {
      final debateInfo = await ApiService(DioClient.dio).getEndedDebateInfo(id);

      state = debateInfo;
    } catch (error) {
      print('Error fetching debate info: $error');
      state = null;
    }
  }
}
