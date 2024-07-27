import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';

final chatProviders = StateNotifierProvider<ChatViewModel, ChatState>(
    (ref) => ChatViewModel(ref));
