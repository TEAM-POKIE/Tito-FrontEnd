import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';

// StateNotifierProvider를 사용하여 DebateInfo 상태 관리
final chatInfoProvider = StateNotifierProvider<ChatViewModel, DebateInfo?>(
  (ref) => ChatViewModel(ref), // ref를 전달하여 ChatViewModel을 초기화
);
