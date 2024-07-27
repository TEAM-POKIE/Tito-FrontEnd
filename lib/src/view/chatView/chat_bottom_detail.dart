import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/core/provider/timer_provider.dart';

class ChatBottomDetail extends ConsumerStatefulWidget {
  const ChatBottomDetail({
    super.key,
  });

  @override
  ConsumerState<ChatBottomDetail> createState() => _ChatBottomDetailState();
}

class _ChatBottomDetailState extends ConsumerState<ChatBottomDetail> {
  void _handleSendMessage() async {
    final loginInfo = ref.read(loginInfoProvider);
    final chatState = ref.read(chatProviders);
    final chatViewModel = ref.read(chatProviders.notifier);
    final timerState = ref.read(timerProvider.notifier);
    final popupViewmodel = ref.read(popupProvider.notifier);
    final popupState = ref.read(popupProvider);

    if (loginInfo == null || chatState.debateData == null) {
      return;
    }
    if (loginInfo.nickname != chatState.debateData!['myNick']) {
      if (chatState.debateData!['opponentTurn'] == 0) {
        popupState.buttonStyle = 1;
        popupState.title = '토론에 참여 하시겠어요?';
        popupState.imgSrc = 'assets/images/chatIconRight.png';

        popupState.buttonContentLeft = '토론 참여하기';

        popupState.content = '작성하신 의견을 전송하면\n토론 개설자에게 보여지고\n토론이 본격적으로 시작돼요!';
        await popupViewmodel.showDebatePopup(context);

        if (popupState.title == '토론이 시작 됐어요! 🎵') {
          if (mounted) {
            chatViewModel.sendMessage();
            timerState.resetTimer();
          }
        }
      } else {
        if (mounted) {
          chatViewModel.sendMessage();
          timerState.resetTimer();
        }
      }
    } else {
      if (mounted) {
        chatViewModel.sendMessage();
        timerState.resetTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);
    final chatState = ref.watch(chatProviders);
    final chatViewModel = ref.read(chatProviders.notifier);

    if (chatState.debateData == null || loginInfo == null) {
      return const SizedBox.shrink();
    }

    final isMyNick = chatState.debateData!['myNick'] == loginInfo.nickname;

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
                if (isMyNick &&
                    chatState.debateData!['myTurn'] ==
                        chatState.debateData!['opponentTurn']) {
                  _handleSendMessage();
                } else if (!isMyNick &&
                    chatState.debateData!['myTurn'] >
                        chatState.debateData!['opponentTurn']) {
                  _handleSendMessage();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              print(chatState.debateData!['myTurn']);
              print(chatState.debateData!['opponentTurn']);
              if (isMyNick &&
                  chatState.debateData!['myTurn'] ==
                      chatState.debateData!['opponentTurn']) {
                _handleSendMessage();
              } else if (!isMyNick &&
                  chatState.debateData!['myTurn'] >
                      chatState.debateData!['opponentTurn']) {
                _handleSendMessage();
              }
            },
            icon: Image.asset('assets/images/sendArrow.png'),
          ),
        ],
      ),
    );
  }
}
