import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';

final chatProviders =
    StateNotifierProvider.family<ChatViewModel, ChatState, String>(
        (ref, roomId) {
  return ChatViewModel(ref, roomId);
});
