import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';

class DebateCreateChat extends ConsumerStatefulWidget {
  const DebateCreateChat({super.key});

  @override
  ConsumerState<DebateCreateChat> createState() => _DebateCreateChatState();
}

class _DebateCreateChatState extends ConsumerState<DebateCreateChat> {
  late WebSocketService webSocketService;

  @override
  void initState() {
    super.initState();
    webSocketService = ref.read(webSocketProvider);

    // 수신된 메시지 로그 출력
    webSocketService.stream.listen((message) {
      print('Received message: $message');
      // 여기에서 메시지를 처리할 수 있습니다.
    }, onError: (error) {
      print('Error in websocket connection: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  @override
  void dispose() {
    webSocketService.dispose(); // WebSocket 연결 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    final webSocketService = ref.read(webSocketProvider);
    final debateState = ref.read(debateCreateProvider);
    final loginInfo = ref.read(loginInfoProvider);

    // DebateCreateState를 활용하여 메시지 생성
    final message = DebateCreateState(
      debateTitle: debateState.debateTitle,
      debateCategory: debateState.debateCategory,
      debateStatus: 'CREATED',
      debateMakerOpinion: debateState.debateMakerOpinion,
      debateJoinerOpinion: debateState.debateJoinerOpinion,
      firstChatContent: _controller.text,
    );

    // JSON 객체를 생성하여 문자열로 인코딩
    final jsonMessage = json.encode({
      'command': 'CREATE',
      'debateId': null,
      'userId': loginInfo!.id,
      'content':
          json.encode(message.toJson()), // message.toJson()을 JSON 문자열로 인코딩
    });

    // WebSocket을 통해 메시지 전송
    webSocketService.sendMessage(jsonMessage);

    // 입력 필드 초기화
    _controller.clear();
    _focusNode.requestFocus(); // 메시지 전송 후 입력 필드에 포커스 유지
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
