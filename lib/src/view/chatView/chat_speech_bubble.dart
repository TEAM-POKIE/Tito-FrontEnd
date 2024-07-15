import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:tito_app/core/provider/turn_provider.dart';

class ChatSpeechBubble extends ConsumerStatefulWidget {
  final String id;

  const ChatSpeechBubble({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _ChatSpeechBubbleState createState() => _ChatSpeechBubbleState();
}

class _ChatSpeechBubbleState extends ConsumerState<ChatSpeechBubble> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _hideBubbleAfterDelay();
  }

  void _hideBubbleAfterDelay() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProviders(widget.id));
    final loginInfo = ref.watch(loginInfoProvider);

    if (chatState.debateData == null || loginInfo == null || !_isVisible) {
      return const SizedBox.shrink();
    }

    final isMyNick = chatState.debateData!['myNick'] == loginInfo.nickname;
    final turnIndex = ref.watch(turnProvider);

    switch (turnIndex) {
      case 0:
        return StaticTextBubble(
          title: '첫 입론을 입력하세요',
          width: (MediaQuery.of(context).size.width - 100) * 0.7,
          height: (MediaQuery.of(context).size.height - 450) * 0.2,
        );
      case 1:
        return StaticTextBubble(
          title: '첫 입론을 입력하세요',
          width: (MediaQuery.of(context).size.width - 100) * 0.7,
          height: (MediaQuery.of(context).size.height - 450) * 0.2,
        );
      default:
        return const Text('안녕');
    }
  }
}

class StaticTextBubble extends StatelessWidget {
  final String title;
  final double width;
  final double height;

  const StaticTextBubble({
    Key? key,
    required this.title,
    required this.width,
    required this.height,
  }) : super(key: key);

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
