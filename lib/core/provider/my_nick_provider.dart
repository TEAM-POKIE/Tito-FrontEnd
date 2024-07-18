import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/api_path.dart';

final myNickProvider = FutureProvider.family<String, String>((ref, id) async {
  final data = await ApiService.getData('debate_list/$id');
  if (data != null && data.containsKey('myNick')) {
    return data['myNick'] as String;
  } else {
    throw Exception('Failed to load myNick');
  }
});
