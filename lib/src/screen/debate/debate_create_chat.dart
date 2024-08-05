import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:speech_balloon/speech_balloon.dart';

import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';

import 'package:tito_app/core/provider/popup_provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

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
    final chatViewModel = ref.read(chatInfoProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        title: Center(
          child: Text(
            debateState.debateTitle,
            style: FontSystem.KR16B,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: ColorSystem.black, size: 24),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/chat_alarm.svg',
            ),
            iconSize: 24,
            onPressed: () {
              chatViewModel.alarmButton(context);
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/dot.svg'),
            onPressed: () {
              debateViewModel.showRulePopup(context);
            },
          ),
        ],
      ),
      body: Container(
        color: ColorSystem.grey3,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: FontSystem.KR14R.copyWith(color: ColorSystem.purple),
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
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                color: ColorSystem.grey3,
                child: StaticTextBubble(
                  title: '첫 입론을 입력해주세요!',
                  width: 180.w,
                ),
              ),
            ),
            ChatBottom(),
          ],
        ),
      ),
    );
  }
}

class StaticTextBubble extends StatelessWidget {
  final String title;
  final double width;

  const StaticTextBubble({
    super.key,
    required this.title,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SpeechBalloon(
      width: width,
      borderRadius: 15.r,
      nipLocation: NipLocation.bottom,
      color: ColorSystem.purple,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: FontSystem.KR16R.copyWith(color: Colors.white),
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
    final debateState = ref.read(debateCreateProvider);
    final popupState = ref.read(popupProvider);
    final popupViewmodel = ref.read(popupProvider.notifier);

    popupState.buttonStyle = 2;
    popupState.buttonContentLeft = '취소';
    popupState.buttonContentRight = '확인';
    popupState.imgSrc = 'assets/images/chatIconRight.svg';
    popupState.content = '토론을 시작하시겠습니까?';
    popupState.title = '토론장을 개설하겠습니까?';
    debateState.firstChatContent = _controller.text;
    debateState.debateStatus = 'CREATED';
    popupViewmodel.showDebatePopup(context);

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
            icon: SvgPicture.asset('assets/icons/sendArrow.svg'),
          ),
        ],
      ),
    );
  }
}
