import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';

class ChatAppbar extends ConsumerWidget {
  const ChatAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProviders);
    // final chatViewModel = ref.read(chatProviders.notifier);
    final loginInfo = ref.read(loginInfoProvider);

    if (chatState.debateData == null) {
      return const LoadingAppbar();
    }

    if (chatState.debateData!['opponentNick'] == '' &&
        loginInfo!.nickname != chatState.debateData!['myNick']) {
      return DebateAppbar(
        // chatViewModel: chatViewModel,
        title: chatState.debateData!['title'] ?? 'No Title',
        notiIcon: 'assets/images/debateAlarm.png',
      );
    }
    return DebateAppbar(
      // chatViewModel: chatViewModel,
      title: chatState.debateData!['title'] ?? 'No Title',
    );
  }
}

class LoadingAppbar extends StatelessWidget {
  const LoadingAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorSystem.white,
      title: const Text('Loading...'),
    );
  }
}

class DebateAppbar extends ConsumerWidget {
  final ChatViewModel? chatViewModel;
  final String title;
  final String? notiIcon;

  const DebateAppbar({
    super.key,
    this.chatViewModel,
    required this.title,
    this.notiIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupViewModel = ref.read(popupProvider.notifier);
    final popupState = ref.read(popupProvider);
    return AppBar(
      backgroundColor: ColorSystem.white,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true, // 타이틀 중앙 정렬
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          chatViewModel!.back(context);
        },
      ),
      actions: [
        if (notiIcon != null && notiIcon!.isNotEmpty)
          IconButton(
            icon: Image.asset(notiIcon!),
            onPressed: () {
              popupState.title = '토론 시작 시 알림을 보내드릴게요!';
              popupState.imgSrc = 'assets/images/debatePopUpAlarm.png';
              popupState.content =
                  '토론 참여자가 정해지고 \n최종 토론이 개설 되면 \n푸시알림을 통해 알려드려요';
              popupState.buttonContentLeft = '네 알겠어요';
              popupState.buttonStyle = 1;
              popupViewModel.showDebatePopup(context);
            },
          ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Image.asset('assets/images/info.png'),
            onPressed: () {
              popupViewModel.showRulePopup(context);
            },
          ),
        ),
      ],
    );
  }
}
