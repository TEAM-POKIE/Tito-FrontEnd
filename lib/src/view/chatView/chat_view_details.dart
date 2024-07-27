import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/timer_provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';
import 'package:speech_balloon/speech_balloon.dart';

class ChatViewDetails extends ConsumerStatefulWidget {
  const ChatViewDetails({
    super.key,
  });

  @override
  _ChatViewDetailsState createState() => _ChatViewDetailsState();
}

class _ChatViewDetailsState extends ConsumerState<ChatViewDetails> {
  @override
  void initState() {
    super.initState();
    ref.read(timerProvider.notifier).startTimer(); // 타이머 시작
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProviders);
    final loginInfo = ref.watch(loginInfoProvider);
    final timerState = ref.watch(timerProvider); // 타이머 상태

    if (chatState.debateData == null || loginInfo == null) {
      return const SizedBox.shrink();
    }

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    String remainingTime = formatDuration(timerState.remainingTime);

    if (chatState.debateData!['myNick'] == loginInfo.nickname) {
      switch (chatState.debateData!['myTurn']) {
        case 1:
          if (chatState.debateData!['opponentTurn'] <
              chatState.debateData!['myTurn']) {
            return _detailState(
              chatState: chatState,
              upImage: 'assets/images/detailChatIcon.png',
              upTitle: '상대 반론자를 찾는 중이에요 !',
            );
          }
          return _detailState(
            chatState: chatState,
            upImage: 'assets/images/detailChatIcon.png',
            upTitle: '${chatState.debateData!['myNick']}님의 반론 타임이에요',
            downTitle: '⏳ $remainingTime 남았어요!',
          );
        default:
          if (chatState.debateData!['opponentTurn'] ==
              chatState.debateData!['myTurn']) {
            return _detailState(
              chatState: chatState,
              upImage: 'assets/images/detailChatIcon.png',
              upTitle: '${chatState.debateData!['myNick']}님의 반론 타임이에요',
              downTitle: '⏳ $remainingTime 남았어요!',
            );
          } else {
            return _detailState(
              chatState: chatState,
              upImage: 'assets/images/detailChatIcon.png',
              upTitle: '상대 반론 타임이에요!',
              downTitle: '⏳ $remainingTime 남았어요!',
            );
          }
      }
    } else if (chatState.debateData!['opponentNick'] == '' ||
        chatState.debateData!['opponentNick'] == loginInfo.nickname) {
      switch (chatState.debateData!['opponentTurn']) {
        case 0:
          return _detailState(
            chatState: chatState,
            upImage: 'assets/images/chatCuteIcon.png',
            downImage: 'assets/images/chatCuteIconPurple.png',
            upTitle: '상대의 의견 : ${chatState.debateData!['myArgument']}',
            downTitle: '당신의 의견 : ${chatState.debateData!['opponentArgument']}',
          );

        default:
          if (chatState.debateData!['opponentTurn'] ==
              chatState.debateData!['myTurn']) {
            return _detailState(
              chatState: chatState,
              upImage: 'assets/images/detailChatIcon.png',
              upTitle: '상대 반론 타임이에요!',
              downTitle: '⏳ $remainingTime 남았어요!',
            );
          } else {
            return _detailState(
              chatState: chatState,
              upImage: 'assets/images/detailChatIcon.png',
              upTitle: '${chatState.debateData!['myNick']}님의 반론 타임이에요',
              downTitle: '⏳ $remainingTime 남았어요!',
            );
          }
      }
    } else {
      return ProfileVsWidget(
        myNick: chatState.debateData!['myNick'],
        opponentNick: chatState.debateData!['opponentNick'],
        myArgument: chatState.debateData!['myArgument'],
        opponentArgument: chatState.debateData!['opponentArgument'],
      );
    }
  }

  @override
  void dispose() {
    ref.read(timerProvider.notifier).stopTimer(); // 타이머 중지
    super.dispose();
  }
}

class firstText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSystem.ligthGrey,
      width: MediaQuery.sizeOf(context).width,
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
  final ChatState chatState;
  final String upImage;
  final String upTitle;
  final String? downImage;
  final String? downTitle;

  const _detailState({
    required this.chatState,
    required this.upImage,
    required this.upTitle,
    this.downTitle,
    this.downImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
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

class ProfileVsWidget extends StatefulWidget {
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
  State<ProfileVsWidget> createState() => _ProfileVsWidgetState();
}

class _ProfileVsWidgetState extends State<ProfileVsWidget> {
  OverlayEntry? _overlayleftEntry;
  OverlayEntry? _overlayrightEntry;

  bool isUpArrowAtFirstProfile = false;
  bool isUpArrowAtSecondProfile = false;
  bool showleftBalloon = false;
  bool showrightBalloon = false;
  void _swapButtons() {
    if (_overlayleftEntry != null) {
      _overlayleftEntry?.remove();
      _overlayleftEntry = null;
    } else {
      _overlayleftEntry = _createOverlayEntry(widget.myArgument, true);
      Overlay.of(context).insert(_overlayleftEntry!);
    }
    setState(() {
      isUpArrowAtFirstProfile = !isUpArrowAtFirstProfile;

      showleftBalloon = !showleftBalloon;
    });
  }

  void _swapSecondButtons() {
    if (_overlayrightEntry != null) {
      _overlayrightEntry?.remove();
      _overlayrightEntry = null;
    } else {
      _overlayrightEntry = _createOverlayEntry(widget.opponentArgument, false);
      Overlay.of(context).insert(_overlayrightEntry!);
    }
    setState(() {
      isUpArrowAtSecondProfile = !isUpArrowAtSecondProfile;
      showrightBalloon = !showrightBalloon;
    });
  }

  OverlayEntry _createOverlayEntry(String message, bool isLeft) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: isLeft ? offset.dx + 50 : null,
        right: isLeft ? null : offset.dx + 20,
        top: offset.dy + 100,
        child: Material(
          color: Colors.transparent,
          child: SpeechBalloon(
            borderRadius: 8,
            nipLocation: NipLocation.topRight,
            nipHeight: 15,
            color: ColorSystem.purple,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                message,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
              TextButton(
                onPressed: _swapButtons,
                child: Row(
                  children: [
                    Text(
                      widget.myNick,
                      style: FontSystem.KR12R,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(width: 4),
                    Image.asset(
                      isUpArrowAtFirstProfile
                          ? 'assets/images/ep_arrow-up.png'
                          : 'assets/images/ep_arrow-down.png',
                      width: 14,
                      height: 14,
                    ),
                  ],
                ),
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
              TextButton(
                onPressed: _swapSecondButtons,
                child: Row(
                  children: [
                    Text(
                      widget.opponentNick,
                      style: FontSystem.KR12R,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(width: 4),
                    Image.asset(
                      isUpArrowAtSecondProfile
                          ? 'assets/images/ep_arrow-up.png'
                          : 'assets/images/ep_arrow-down.png',
                      width: 14,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
