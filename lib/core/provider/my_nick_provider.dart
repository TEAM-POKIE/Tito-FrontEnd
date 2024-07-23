import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

final myNickProvider = FutureProvider.family<String, String>((ref, id) async {
  final apiService = ApiService(DioClient.dio); // ApiService 인스턴스 생성
  final data = await apiService.getData('debate_list/$id');
  if (data != null && data.containsKey('myNick')) {
    return data['myNick'] as String;
  } else {
    throw Exception('Failed to load myNick');
  }
});
