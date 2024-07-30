import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';

import 'package:tito_app/src/data/models/debate_crate.dart';
import 'package:tito_app/src/data/models/popup_state.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';

class DebateCreateChat extends ConsumerStatefulWidget {
  const DebateCreateChat({super.key});

  @override
  ConsumerState<DebateCreateChat> createState() => _DebateCreateChatState();
}

class _DebateCreateChatState extends ConsumerState<DebateCreateChat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

  void _sendMessage() async {
    final debateState = ref.read(debateCreateProvider);
    final popupState = ref.read(popupProvider);
    final PopupViewmodel = ref.read(popupProvider.notifier);
    popupState.buttonStyle = 2;
    popupState.buttonContentLeft = '취소';
    popupState.buttonContentRight = '확인';
    popupState.imgSrc = 'assets/images/chatIconRight.png';
    popupState.content = '토론을 시작하시겠습니까?';
    popupState.title = '토론장을 개설하겠습니까?';
    PopupViewmodel.showDebatePopup(context);
    debateState.firstChatContent = _controller.text;
    debateState.debateStatus = 'CREATED';
    _controller.clear();
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
