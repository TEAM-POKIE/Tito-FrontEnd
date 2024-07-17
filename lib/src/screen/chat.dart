import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/live_comment.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/login_info.dart';
import 'package:tito_app/src/view/chatView/chat_appBar.dart';
import 'package:tito_app/src/view/chatView/chat_body.dart';
import 'package:tito_app/src/view/chatView/live_comment.dart';
import 'package:tito_app/src/viewModel/chat_viewModel.dart';

class Chat extends ConsumerWidget {
  final String id; // 채팅방 고유 ID
  final int turn = 0;

  const Chat({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProviders(id));
    final loginInfo = ref.watch(loginInfoProvider);
    if (loginInfo!.nickname == chatState.debateData!['myNick'] ||
        loginInfo.nickname == chatState.debateData!['opponentNick'] ||
        chatState.debateData!['opponentNick'] == '') {
      return _BasicDebate(
        id: id,
        chatState: chatState,
      );
    } else {
      return _LiveComment(
        id: id,
        loginInfo: loginInfo!,
        chatState: chatState,
      );
    }
  }
}

class _BasicDebate extends StatelessWidget {
  final ChatState chatState;
  final String id;

  const _BasicDebate({
    Key? key,
    required this.id,
    required this.chatState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ChatAppbar(id: id), // id 전달
      ),
      body: chatState.debateData != null
          ? ChatBody(id: id)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _LiveComment extends StatelessWidget {
  final LoginInfo loginInfo;
  final ChatState chatState;
  final String id;
  final PanelController _panelController = PanelController();

  _LiveComment({
    Key? key,
    required this.loginInfo,
    required this.id,
    required this.chatState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: ChatAppbar(id: id), // id 전달
      ),
      body: chatState.debateData != null
          ? SlidingUpPanel(
              header: Container(
                width: MediaQuery.of(context).size.width - 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  '방청객 실시간 댓글',
                  style: FontSystem.KR20B,
                  textAlign: TextAlign.center,
                ),
              ),
              controller: _panelController,
              panelBuilder: (scrollController) => LiveComment(
                username: loginInfo.nickname,
                id: id,
                scrollController: scrollController,
              ),
              body: GestureDetector(
                onTap: () {
                  _panelController.close();
                },
                child: ChatBody(id: id),
              ),
              backdropEnabled: true,
              backdropOpacity: 0.5,
              minHeight: 40, // 패널의 최소 높이 설정
              maxHeight:
                  MediaQuery.of(context).size.height * 0.5, // 패널의 최대 높이 설정
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              isDraggable: true,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
