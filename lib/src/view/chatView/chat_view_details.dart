import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tito_app/core/constants/style.dart';

import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/timer_provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/view/chatView/live_comment.dart';
import 'package:tito_app/src/view/chatView/votingbar.dart';

class ChatViewDetails extends HookConsumerWidget {
  final int id;
  const ChatViewDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginInfo = ref.watch(loginInfoProvider);
    final timerState = ref.watch(timerProvider); // 타이머 상태

    useEffect(() {
      ref.read(timerProvider.notifier).startTimer(); // 타이머 시작
      return () => ref.read(timerProvider.notifier).stopTimer(); // 타이머 정지
    }, []);

    if (loginInfo == null) {
      return const SizedBox.shrink();
    }

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    String remainingTime = formatDuration(timerState.remainingTime);

    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: _detailState(
                  upImage: 'assets/images/detailChatIcon.png',
                  upTitle: '상대 반론자를 찾는 중이예요 !',
                  downTitle: '⏳ 00:00 토론 시작 전')),
        ],
      ),
    );
  }
}

class firstText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSystem.ligthGrey,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Padding(
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
      ),
    );
  }
}

class _detailState extends StatelessWidget {
  // final DebateInfo chatState;
  final String upImage;
  final String upTitle;
  final String? downImage;
  final String? downTitle;

  const _detailState({
    // required this.chatState,
    required this.upImage,
    required this.upTitle,
    this.downTitle,
    this.downImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 5),
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: (upImage == 'assets/images/chatCuteIcon.png')
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
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
          const SizedBox(height: 3),
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: (upImage == 'assets/images/chatCuteIcon.png')
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  downImage != null && downImage!.isNotEmpty
                      ? Image.asset(downImage!)
                      : const SizedBox(width: 0),
                  const SizedBox(width: 8),
                  Text(
                    downTitle ?? '',
                    style: downImage != null && downImage!.isNotEmpty
                        ? FontSystem.KR16B
                        : FontSystem.KR16B.copyWith(color: ColorSystem.purple),
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
  final String myArgument;
  final String opponentNick;
  final String opponentArgument;

  const ProfileVsWidget({
    required this.myNick,
    required this.myArgument,
    required this.opponentNick,
    required this.opponentArgument,
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
                radius: 30,
                backgroundImage: AssetImage('assets/images/chatCuteIcon.png'),
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
                  '토론 진행중',
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
                radius: 30,
                backgroundImage: AssetImage(
                    'assets/images/chatCuteIcon.png'), // 두 번째 프로필 이미지
              ),
            ],
          ),
        ],
      ),
    );
  }
}
