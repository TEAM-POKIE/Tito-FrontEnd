import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/timer_provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tito_app/src/view/chatView/live_comment.dart';
import 'package:tito_app/src/view/chatView/votingbar.dart';

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
    final timerState = ref.watch(timerProvider);
    final chatViewModel = ref.watch(chatInfoProvider.notifier);
    final chatState = ref.watch(chatInfoProvider);

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

    if (chatState!.debateJoinerId == loginInfo.id ||
        chatState.debateOwnerId == loginInfo.id) {
      return _DetailState(
          upImage: 'assets/images/detailChatIcon.svg',
          upTitle: '상대 반론자를 찾는 중이예요 !',
          downTitle: '⏳ ${remainingTime} 토론 시작 전');
    } else {
      switch (chatState.debateJoinerTurnCount) {
        case 0:
          return _DetailState(
            upImage: 'assets/images/chatCuteIcon.svg',
            upTitle: '상대의 의견 : ${chatState.debateMakerOpinion}',
            downTitle: '당신의 의견 : ${chatState.debateJoinerOpinion}',
            downImage: 'assets/images/chatCuteIconPurple.svg',
          );

        default:
          return SizedBox(
            width: 0,
          );
      }
    }
  }
}

class _DetailState extends StatelessWidget {
  final String upImage;
  final String upTitle;
  final String? downImage;
  final String? downTitle;

  const _DetailState({
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
      color: ColorSystem.white,
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
                mainAxisAlignment: (upImage == 'assets/images/chatCuteIcon.svg')
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
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
                color: downImage == 'assets/images/chatCuteIconPurple.svg'
                    ? ColorSystem.lightPurple
                    : ColorSystem.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: (upImage == 'assets/images/chatCuteIcon.svg')
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  downImage != null && downImage!.isNotEmpty
                      ? SvgPicture.asset(downImage!)
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
