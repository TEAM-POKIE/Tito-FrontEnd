import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:speech_balloon/speech_balloon.dart';

import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/debate_create_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 200.0,
                ),
                child: Text(
                  debateState.debateTitle,
                  overflow: TextOverflow.ellipsis,
                  style: FontSystem.KR16SB,
                ),
              ),
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero, // 아이콘 버튼 간 패딩 없애기 1
                constraints: BoxConstraints(), // 아이콘 버튼 간 패딩 없애기 2
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 30.sp,
              ),
            ],
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
            padding: EdgeInsets.zero, // 아이콘 버튼 간 패딩 없애기 1
            constraints: BoxConstraints(), // 아이콘 버튼 간 패딩 없애기 2
            icon: Icon(Icons.more_vert),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/chat_cute.svg'),
                    SizedBox(width: 5.w),
                    Text('토론방이 개설되려면 당신의 첫 입론이 필요합니다.',
                        style: FontSystem.KR14SB
                            .copyWith(color: ColorSystem.purple)),
                  ],
                ),
                Text('입론을 잘성해주세요 !',
                    style:
                        FontSystem.KR14SB.copyWith(color: ColorSystem.purple)),
              ],
            ),
            Expanded(
              child: Container(
                height: 56.h,
                alignment: Alignment.bottomCenter,
                color: ColorSystem.grey3,
                child: AnimatedTextBubble(
                  title: '첫 입론을 입력해주세요!',
                  width: 180.w,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ChatBottom(),
          ],
        ),
      ),
    );
  }
}

class AnimatedTextBubble extends StatefulWidget {
  final String title;
  final double width;

  const AnimatedTextBubble({required this.title, required this.width});

  @override
  _AnimatedTextBubbleState createState() => _AnimatedTextBubbleState();
}

class _AnimatedTextBubbleState extends State<AnimatedTextBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0.1), // 위아래로 움직이는 범위 설정
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        width: widget.width,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: ColorSystem.purple, // 버블 배경색
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: FontSystem.KR16SB.copyWith(color: Colors.white),
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
    popupState.imgSrc = 'assets/icons/chatIconRight.svg';
    popupState.content = '토론을 시작하시겠어요?';
    popupState.title = '토론장을 개설하시겠어요?';
    debateState.firstChatContent = _controller.text;
    debateState.debateStatus = 'CREATED';
    popupViewmodel.showDebatePopup(context);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      color: Colors.white, // 입력바 배경색 설정
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/plus.svg'),
            ),
            Expanded(
              child: Container(
                width: 320.w,
                height: 40.h,
                child: TextField(
                  controller: _controller,
                  autocorrect: false,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: '첫 입론을 입력해주세요 !',
                    hintStyle:
                        FontSystem.KR16M.copyWith(color: ColorSystem.grey),
                    fillColor: ColorSystem.ligthGrey,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 20.w), // 세로 가운데 정렬을 위한 패딩 설정
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    _sendMessage();
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: SvgPicture.asset('assets/icons/final_send_arrow.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
