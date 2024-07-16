import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';

import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/turn_provider.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatViewDetails extends ConsumerWidget {
  final String id;
  const ChatViewDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProviders(id));
    final turnIndex = ref.watch(turnProvider.notifier);
    switch (turnIndex.state) {
      case 0:
        return _turn0State(
          chatState: chatState,
        );
      case 1:
        return _turn1State(
          chatState: chatState,
        );
      default:
        return Text('안녕');
    }
  }
}

class _turn0State extends StatelessWidget {
  final ChatState chatState;

  const _turn0State({Key? key, required this.chatState});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: FontSystem.KR12B.copyWith(color: ColorSystem.purple),
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            FadeAnimatedText('토론방이 개설되려면 당신의 첫 입론이 필요합니다.\n입론을 작성해주세요!',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _turn1State extends StatelessWidget {
  final ChatState chatState;

  const _turn1State({Key? key, required this.chatState});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: (MediaQuery.of(context).size.height - 500) * 0.7,
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/chatprofile.png'),
              const SizedBox(width: 8),
              Text(
                chatState.debateData!['myNick'],
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                ':',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                chatState.debateData!['myArgument'] ?? '',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset('assets/images/chatprofile.png'),
              const SizedBox(width: 8),
              Text(
                chatState.debateData!['opponentNick'] != ''
                    ? chatState.debateData!['opponentNick']
                    : '당신의 의견',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                ':',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                chatState.debateData!['opponentArgument'] ?? '',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
