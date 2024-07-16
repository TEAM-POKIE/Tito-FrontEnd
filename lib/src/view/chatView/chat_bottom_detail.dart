import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/login_info.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';

class ChatBottomDetail extends ConsumerWidget {
  final String id;
  const ChatBottomDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginInfo = ref.watch(loginInfoProvider);
    final chatState = ref.watch(chatProviders(id));
    final chatViewModel = ref.read(chatProviders(id).notifier);
    switch (chatState.debateData) {
      case null:
        return Text('s');
      default:
        return ChatSend(
          chatViewModel: chatViewModel,
          chatState: chatState,
          loginInfo: loginInfo!,
        );
    }
  }
}

class ChatSend extends StatelessWidget {
  final ChatViewModel chatViewModel;
  final ChatState chatState;
  final LoginInfo loginInfo;

  const ChatSend({
    Key? key,
    required this.chatViewModel,
    required this.loginInfo,
    required this.chatState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatViewModel.controller,
              autocorrect: false,
              focusNode: chatViewModel.focusNode,
              decoration: InputDecoration(
                hintText: '상대 의견 작성 타임이에요!',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                chatViewModel.sendMessage();
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              if (chatState.debateData?['opponentNick'] == '' &&
                  chatState.debateData?['myNick'] != loginInfo.nickname) {
                final popupResult =
                    await chatViewModel.showDebatePopup(context);
                if (popupResult) {
                  await chatViewModel.sendMessage();
                }
              } else if (chatState.debateData!['turnId'] !=
                  loginInfo.nickname) {
                chatViewModel.sendMessage();
              }
            },
            icon: Image.asset('assets/images/sendArrow.png'),
          ),
        ],
      ),
    );
  }
}
