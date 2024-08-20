import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tito_app/src/data/models/ended_chat.dart';

import 'package:tito_app/src/viewModel/ended_viewModel.dart';

// StateNotifierProvider를 사용하여 DebateInfo 상태 관리
final endedProvider = StateNotifierProvider<EndedViewModel, EndedChatInfo?>(
  (ref) => EndedViewModel(ref), // ref를 전달하여 ChatViewModel을 초기화
);
