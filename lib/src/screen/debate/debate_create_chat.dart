import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';

import 'package:tito_app/src/view/chatView/chat_view_details.dart';

class DebateCreateChat extends ConsumerWidget {
  const DebateCreateChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debateState = ref.watch(debateCreateProvider);
    final debateViewModel = ref.read(debateCreateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(debateState.debateTitle),
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
              debateViewModel.showDebatePopup(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Image.asset('assets/images/info.png'),
              onPressed: () {
                debateViewModel.showRulePopup(context);
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

  void _sendMessage() {
    ref.read(debateCreateProvider.notifier).sendMessage(context, _controller);
    _focusNode.requestFocus(); // 메시지를 보낸 후 포커스를 유지합니다.
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
