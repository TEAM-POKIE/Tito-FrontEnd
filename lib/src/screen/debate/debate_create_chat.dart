import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';

import 'package:tito_app/src/view/chatView/chat_view_details.dart';

class DebateCreateChat extends ConsumerWidget {
  const DebateCreateChat({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debateState = ref.watch(debateCreateProvider);
    final popupViewModel = ref.read(popupProvider.notifier);
    final popupState = ref.read(popupProvider);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            debateState.debateTitle,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/debateAlarm.png'),
            onPressed: () {
              popupState.title = '토론 시작 시 알림을 보내드릴게요!';
              popupState.imgSrc = 'assets/images/debatePopUpAlarm.png';
              popupState.content =
                  '토론 참여자가 정해지고 \n최종 토론이 개설 되면 \n푸시알림을 통해 알려드려요';
              popupState.buttonContentLeft = '네 알겠어요';
              popupState.buttonStyle = 1;
              popupViewModel.showDebatePopup(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Image.asset('assets/images/info.png'),
              onPressed: () {
                popupViewModel.showRulePopup(context);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          firstText(),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.sizeOf(context).width,
              color: ColorSystem.ligthGrey,
              child: StaticTextBubble(
                title: '첫 입론을 입력하세요',
                width: (MediaQuery.of(context).size.width - 100) * 0.7,
                height: (MediaQuery.of(context).size.height - 450) * 0.2,
              ),
            ),
          ),
          ChatBottom(),
        ],
      ),
    );
  }
}

class StaticTextBubble extends StatelessWidget {
  final String title;
  final double width;
  final double height;

  const StaticTextBubble({
    super.key,
    required this.title,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SpeechBalloon(
      width: width,
      height: height,
      borderRadius: 12,
      nipLocation: NipLocation.bottom,
      color: ColorSystem.purple,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: FontSystem.KR16B.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class ChatBottom extends ConsumerStatefulWidget {
  const ChatBottom({super.key});

  @override
  ConsumerState<ChatBottom> createState() => _ChatBottomDetailState();
}

class _ChatBottomDetailState extends ConsumerState<ChatBottom> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final debateState = ref.watch(debateCreateProvider);
    final text = _controller.text;
    if (text.isNotEmpty) {
      // 메시지를 서버로 전송하는 API 호출

      _controller.clear();
      _focusNode.requestFocus(); // 메시지를 보낸 후 포커스를 유지합니다.

      // 새로운 화면으로 이동 (채팅방)
      context.push('/chat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autocorrect: false,
              focusNode: _focusNode,
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
                _sendMessage();
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: Image.asset('assets/images/sendArrow.png'),
          ),
        ],
      ),
    );
  }
}
