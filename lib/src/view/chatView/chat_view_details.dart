import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
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
    final turnIndex = ref.watch(turnProvider);
    final loginInfo = ref.watch(loginInfoProvider);

    if (chatState.debateData == null || loginInfo == null) {
      return const SizedBox
          .shrink(); // Null check and return an empty widget if needed
    }

    final isMyNick = chatState.debateData!['myNick'] == loginInfo.nickname;

    if (isMyNick) {
      switch (turnIndex.myTurn) {
        case 0:
          return _text(
            chatState: chatState,
          );

        case 1:
          if (turnIndex.opponentTurn == 0) {
            return _detailState(
              chatState: chatState,
              upImage: 'assets/images/detailChatIcon.png',
              upTitle: '상대 반론자를 찾는 중이에요 !',
            );
          }
          return _detailState(
            chatState: chatState,
            upImage: 'assets/images/detailChatIcon.png',
            downImage: 'assets/images/chatCuteIconPurple.png',
            upTitle: '상대의 의견을 반박하며 토론을 시작해보세요!',
          );
        default:
          return const Text('잘못된 상태입니다.');
      }
    } else {
      switch (turnIndex.opponentTurn) {
        case 0:
          return _detailState(
            chatState: chatState,
            upImage: 'assets/images/chatCuteIcon.png',
            downImage: 'assets/images/chatCuteIconPurple.png',
            upTitle: '상대의 의견 : ${chatState.debateData!['myArgument']}',
            downTitle: '당신의 의견 : ${chatState.debateData!['opponentArgument']}',
            //opponentArgument,
          );
        case 1:
          return _detailState(
            chatState: chatState,
            upImage: 'assets/images/chatCuteIcon.png',
            downImage: 'assets/images/chatCuteIconPurple.png',
            upTitle: '상대의 의견',
          );
        default:
          return const Text('잘못된 상태입니다.');
      }
    }
  }
}

class _text extends StatelessWidget {
  final ChatState chatState;

  const _text({Key? key, required this.chatState}) : super(key: key);

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
            FadeAnimatedText(
              '토론방이 개설되려면 당신의 첫 입론이 필요합니다.\n입론을 작성해주세요!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _detailState extends StatelessWidget {
  final ChatState chatState;
  final String upImage;
  final String upTitle;
  final String? downImage;
  final String? downTitle;

  const _detailState({
    Key? key,
    required this.chatState,
    required this.upImage,
    required this.upTitle,
    this.downTitle,
    this.downImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(
                    upImage,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    upTitle,
                    style: FontSystem.KR16R,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(
                color: downImage == 'assets/images/chatCuteIconPurple.png'
                    ? ColorSystem.lightPurple
                    : ColorSystem.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  downImage != null && downImage!.isNotEmpty
                      ? Image.asset(downImage!)
                      : const SizedBox(width: 0),
                  const SizedBox(width: 8),
                  Text(
                    downTitle ?? '',
                    style: FontSystem.KR16R,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
