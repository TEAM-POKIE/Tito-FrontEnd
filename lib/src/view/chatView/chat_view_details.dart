import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/timer_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ChatViewDetails extends ConsumerStatefulWidget {
  final int id;
  const ChatViewDetails({super.key, required this.id});

  @override
  ConsumerState<ChatViewDetails> createState() => _ChatViewDetailsState();
}

class _ChatViewDetailsState extends ConsumerState<ChatViewDetails> {
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
    final loginInfo = ref.watch(loginInfoProvider);

    final chatState = ref.watch(chatInfoProvider);

    if (loginInfo == null) {
      return const SizedBox.shrink();
    }
    final timerState = ref.watch(timerProvider);
    final chatViewModel = ref.watch(chatInfoProvider.notifier);
    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    String remainingTime = formatDuration(chatState!.remainingTime);
    if (chatState.debateStatus == 'ENDED') {
      return EndedProfileVsWidget(
          myNick: chatState.debateOwnerNick,
          myImage: chatState.debateOwnerPicture,
          opponentNick: chatState.debateJoinerNick,
          opponentImage: chatState.debateJoinerPicture);
    } else if (chatState.debateJoinerId == loginInfo.id ||
        chatState.debateOwnerId == loginInfo.id) {
      switch (chatState.debateJoinerTurnCount) {
        case 0:
          return DetailState(
              upImage: 'assets/images/detailChatIcon.svg',
              upTitle: '상대 반론자를 찾는 중이예요 !',
              downTitle: '⏳ 00:00 토론 시작 전');
        default:
          return DetailState(
              upImage: 'assets/images/detailChatIcon.svg',
              upTitle: '상대 반론 타임이에요!',
              downTitle: '⏳ ${remainingTime} 남았어요!');
      }
    } else {
      switch (chatState.debateJoinerTurnCount) {
        case 0:
          return DetailState(
            upImage: 'assets/images/chatCuteIcon.svg',
            upTitle: '상대의 의견 : ${chatState.debateMakerOpinion}',
            downTitle: '당신의 의견 : ${chatState.debateJoinerOpinion}',
            downImage: 'assets/images/chatCuteIconPurple.svg',
          );
        default:
          if (chatState.debateStatus == 'VOTING') {
            return ProfileVsWidget(
                myNick: chatState.debateOwnerNick,
                myImage: chatState.debateOwnerPicture,
                opponentNick: chatState.debateJoinerNick,
                opponentImage: chatState.debateJoinerPicture);
          } else {
            return SizedBox(
              width: 0,
            );
          }
      }
    }
  }
}

class DetailState extends StatelessWidget {
  final String upImage;
  final String upTitle;
  final String? downImage;
  final String? downTitle;

  const DetailState({
    required this.upImage,
    required this.upTitle,
    this.downTitle,
    this.downImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      color: ColorSystem.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: (upImage == 'assets/images/chatCuteIcon.svg')
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    upImage,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    upTitle,
                    style: FontSystem.KR16SB,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: downImage == 'assets/images/chatCuteIconPurple.svg'
                    ? ColorSystem.lightPurple
                    : ColorSystem.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: (upImage == 'assets/images/chatCuteIcon.svg')
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  downImage != null && downImage!.isNotEmpty
                      ? SvgPicture.asset(downImage!)
                      : SizedBox(width: 0.w),
                  Text(
                    downTitle ?? '',
                    style: downImage != null && downImage!.isNotEmpty
                        ? FontSystem.KR16SB
                        : FontSystem.KR16SB.copyWith(color: ColorSystem.purple),
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

class ProfileVsWidget extends StatelessWidget {
  final String myNick;
  final String myImage;
  final String opponentNick;
  final String opponentImage;

  const ProfileVsWidget({
    required this.myNick,
    required this.myImage,
    required this.opponentNick,
    required this.opponentImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSystem.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: NetworkImage(opponentImage),
              ),
              Text(opponentNick),
            ],
          ),
          SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xffE8DAFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '투표 중',
                  style: FontSystem.KR14B.copyWith(color: ColorSystem.purple),
                ),
              ),
              SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxWidth: 250),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: ColorSystem.black,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  'VS',
                  style: FontSystem.KR16B.copyWith(color: ColorSystem.white),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: NetworkImage(myImage),
              ),
              Text(myNick),
            ],
          ),
        ],
      ),
    );
  }
}

class EndedProfileVsWidget extends StatefulWidget {
  final String myNick;
  final String myImage;
  final String opponentNick;
  final String opponentImage;

  const EndedProfileVsWidget({
    required this.myNick,
    required this.myImage,
    required this.opponentNick,
    required this.opponentImage,
  });

  @override
  State<EndedProfileVsWidget> createState() => _EndedProfileVsWidgetState();
}

class _EndedProfileVsWidgetState extends State<EndedProfileVsWidget> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play(); // 시작할 때 confetti를 재생합니다.
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSystem.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: NetworkImage(widget.opponentImage),
              ),
              ConfettiWidget(
                confettiController: _confettiController,
                // blastDirectionality: BlastDirectionality.explosive,
                blastDirection: -pi / 2,
                maxBlastForce: 10,
                minBlastForce: 5,
                emissionFrequency: 0.05,
                numberOfParticles: 5,
                gravity: 0.1,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
              ),
            ],
          ),
          SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xffE8DAFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '토론 종료',
                  style: FontSystem.KR14B.copyWith(color: ColorSystem.purple),
                ),
              ),
              SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxWidth: 250),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: ColorSystem.black,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '승! VS 패',
                  style: FontSystem.KR16B.copyWith(color: ColorSystem.white),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: NetworkImage(widget.myImage),
              ),
              Text(widget.myNick),
            ],
          ),
        ],
      ),
    );
  }
}
