import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/core/provider/turn_provider.dart';

class ChatBottomDetail extends ConsumerWidget {
  final String id;
  const ChatBottomDetail({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginInfo = ref.watch(loginInfoProvider);
    final chatState = ref.watch(chatProviders(id));
    final chatViewModel = ref.read(chatProviders(id).notifier);
    final turnState = ref.watch(turnProvider.notifier);
    final turnIndex = ref.watch(turnProvider);
    final popupViewmodel = ref.watch(popupProvider.notifier);
    final popupState = ref.watch(popupProvider);
    void handleSendMessage() async {
      if (loginInfo!.nickname != chatState.debateData!['myNick']) {
        if (turnIndex.opponentTurn == 0) {
          popupState.buttonStyle = 1;
          popupState.title = '토론에 참여 하시겠어요?';
          popupState.imgSrc = 'assets/images/chatIconRight.png';
          popupState.buttonContentLeft = '토론 참여하기';
          popupState.content = '작성하신 의견을 전송하면\n토론 개설자에게 보여지고\n토론이 본격적으로 시작돼요!';
          await popupViewmodel.showDebatePopup(context);
          if (popupState.title == '토론이 시작 됐어요! 🎵') {
            turnState.incrementOpponentTurn();
            chatViewModel.sendMessage();
          }
        } else {
          chatViewModel.sendMessage();
        }
      } else {
        turnState.incrementMyTurn();

        chatViewModel.sendMessage();
      }
    }

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
                if (chatState.debateData!['turnId'] != loginInfo!.nickname) {
                  handleSendMessage();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              if (chatState.debateData!['turnId'] != loginInfo!.nickname) {
                handleSendMessage();
              }
            },
            icon: Image.asset('assets/images/sendArrow.png'),
          ),
        ],
      ),
    );
  }
}
