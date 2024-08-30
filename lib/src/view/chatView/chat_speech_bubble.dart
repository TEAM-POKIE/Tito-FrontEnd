import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';

import 'package:tito_app/core/provider/login_provider.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/data/models/popup_state.dart';
import 'package:tito_app/src/view/chatView/live_comment.dart';
import 'package:tito_app/src/view/chatView/votingbar.dart';
import 'package:tito_app/src/viewModel/popup_viewModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatSpeechBubble extends ConsumerStatefulWidget {
  const ChatSpeechBubble({
    super.key,
  });

  @override
  _ChatSpeechBubbleState createState() => _ChatSpeechBubbleState();
}

class _ChatSpeechBubbleState extends ConsumerState<ChatSpeechBubble> {
  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);
    final popupViewModel = ref.read(popupProvider.notifier);
    final popupState = ref.read(popupProvider);
    final chatState = ref.read(chatInfoProvider);

    // if (chatState.debateData == null || loginInfo == null) {
    //   return const SizedBox.shrink();
    //   // }

    //   // // final myNick = chatState.debateData?['myNick'];
    //   // // final opponentNick = chatState.debateData?['opponentNick'];
    //   // // final myTurn = chatState.debateData?['myTurn'];
    //   // // final opponentTurn = chatState.debateData?['opponentTurn'];
    //   // final isMyNick = myNick == loginInfo.nickname;

    //   // if (myNick == null ||
    //   //     opponentNick == null ||
    //   //     myTurn == null ||
    //   //     opponentTurn == null) {
    //   return const SizedBox.shrink();
    // }

    // String sendNick = isMyNick ? myNick : opponentNick;
    if (chatState!.debateJoinerId == loginInfo!.id ||
        chatState.debateOwnerId == loginInfo.id) {
      switch (chatState.debateJoinerTurnCount) {
        case 0:
        default:
          if (chatState.debateJoinerTurnCount > 2) {
            return Column(
              children: [
                chatState.canTiming == true
                    ? TimingButton(
                        popupViewModel: popupViewModel,
                        popupState: popupState,
                        imgSrc: 'assets/icons/timingBell.svg',
                        content: '타이밍 벨')
                    : SizedBox(
                        width: 0.w,
                      ),
              ],
            );
          } else {
            SizedBox(
              width: 0.w,
            );
          }
      }
    } else {
      switch (chatState.debateJoinerTurnCount) {
        case 0:
          return StaticTextBubble(
            title: '토론 참여자를 기다리고 있어요!\n의견을 작성해보세요',
            width: 210.w,
            height: 64.h,
          );

        default:
          if (chatState.debateJoinerTurnCount > 2) {
            return Column(
              children: [
                TimingButton(
                  popupViewModel: popupViewModel,
                  popupState: popupState,
                  imgSrc: 'assets/icons/voting.svg',
                  content: '투표하기',
                ),
                const VotingBar(),
                LiveComment(),
              ],
            );
          }
          return LiveComment();
      }
    }

    return const SizedBox.shrink();
  }
}

class StaticTextBubble extends StatefulWidget {
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
  _StaticTextBubbleState createState() => _StaticTextBubbleState();
}

class _StaticTextBubbleState extends State<StaticTextBubble>
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
    return Container(
      color: ColorSystem.grey3,
      width: 390.w,
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
      ),
      child: SlideTransition(
        position: _animation,
        child: SpeechBalloon(
          width: widget.width,
          height: widget.height,
          borderRadius: 15.r,
          nipLocation: NipLocation.bottom,
          color: ColorSystem.purple,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: FontSystem.KR16R.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class TimingButton extends StatelessWidget {
  final PopupViewmodel? popupViewModel;
  final PopupState? popupState;
  final String content;
  final String imgSrc;

  const TimingButton({
    super.key,
    this.popupViewModel,
    this.popupState,
    required this.imgSrc,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSystem.grey3,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.black,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            onPressed: () {
              if (content == '타이밍 벨') {
                popupViewModel!.showTimingPopup(context, 'timing');
              } else {
                popupViewModel!.showTimingPopup(context, 'vote');
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  imgSrc,
                  width: 20.w, // 아이콘 크기 조정
                  height: 20.h,
                ),
                const SizedBox(width: 4),
                Text(
                  content,
                  style: FontSystem.KR16B.copyWith(color: ColorSystem.yellow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
