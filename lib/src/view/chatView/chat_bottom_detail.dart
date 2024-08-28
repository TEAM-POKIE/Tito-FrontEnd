import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/provider/ai_response_provider.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/core/provider/timer_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

class ChatBottomDetail extends ConsumerStatefulWidget {
  final int id;
  const ChatBottomDetail({super.key, required this.id});

  @override
  ConsumerState<ChatBottomDetail> createState() => _ChatBottomDetailState();
}

class _ChatBottomDetailState extends ConsumerState<ChatBottomDetail> {
  void handleSendMessage(BuildContext context) async {
    final loginInfo = ref.read(loginInfoProvider);
    final chatViewModel = ref.read(chatInfoProvider.notifier);
    final chatState = ref.read(chatInfoProvider);
    final popupState = ref.read(popupProvider);

    if (loginInfo == null) {
      print("Error: loginInfo is null");
      return;
    }

    if (chatState == null) {
      print("Error: chatState is null");
      return;
    }

    if (chatState.debateJoinerId == 0 &&
        chatState.debateJoinerTurnCount == 0 &&
        chatState.debateOwnerId != loginInfo.id) {
      final popupViewModel = ref.read(popupProvider.notifier);
      final popupState = ref.read(popupProvider);

      popupState
        ..buttonStyle = 1
        ..title = '토론에 참여하시겠습니까?'
        ..imgSrc = 'assets/icons/popup_face.svg'
        ..buttonContentLeft = '토론 참여하기'
        ..content = '작성하신 의견을 전송하면\n토론 개설자에게 보여지고\n토론이 본격적으로 시작돼요!';

      await popupViewModel.showDebatePopup(context);
      chatViewModel.sendJoinMessage(context);
    } else if (chatState.debateJoinerId == loginInfo.id ||
        chatState.debateOwnerId == loginInfo.id) {
      setState(() {
        chatViewModel.sendMessage();
      });
    } else {
      chatViewModel.sendChatMessage();
    }

    if (popupState.title == '토론이 시작 됐어요! 🎵') {
      if (mounted) {
        ref.read(timerProvider.notifier).resetTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      child: Column(
        children: [
          const ApiResponseBubble(),
          Row(
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
                    controller: ref.read(chatInfoProvider.notifier).controller,
                    autocorrect: false,
                    focusNode: ref.read(chatInfoProvider.notifier).focusNode,
                    decoration: InputDecoration(
                      hintText: '상대 의견 작성 타임이에요!',
                      hintStyle:
                          FontSystem.KR16M.copyWith(color: ColorSystem.grey),
                      fillColor: ColorSystem.ligthGrey,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      handleSendMessage(context);
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  handleSendMessage(context);
                },
                icon: SvgPicture.asset('assets/icons/final_send_arrow.svg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApiResponseBubble extends ConsumerWidget {
  const ApiResponseBubble({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiResponse = ref.watch(aiResponseProvider);
    final chatState = ref.watch(chatInfoProvider);

    print(chatState!.explanation);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chatState.explanation != null)
            ...chatState.explanation!
                .map((explanation) => Text(explanation))
                .toList()
          else
            Text('No explanation available'),
        ],
      ),
    );
  }
}
