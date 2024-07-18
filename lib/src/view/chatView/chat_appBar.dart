import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';
import 'package:go_router/go_router.dart';

class ChatAppbar extends ConsumerWidget {
  final String id;

  const ChatAppbar({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProviders(id));
    final chatViewModel = ref.read(chatProviders(id).notifier);

    switch (chatState.debateData) {
      case null:
        return const LoadingAppbar();
      default:
        return DebateAppbar(
            chatViewModel: chatViewModel,
            title: chatState.debateData!['title'] ?? 'No Title');
    }
  }
}

class LoadingAppbar extends StatelessWidget {
  const LoadingAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('Loading...'),
    );
  }
}

class DebateAppbar extends StatelessWidget {
  final ChatViewModel chatViewModel;
  final String title;

  const DebateAppbar({
    super.key,
    required this.chatViewModel,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          chatViewModel.back(context);
        },
      ),
      actions: [
        IconButton(
          icon: Image.asset('assets/images/info.png'),
          onPressed: () {
            // 추가 작업
          },
        ),
      ],
    );
  }
}
