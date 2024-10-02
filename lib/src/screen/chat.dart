import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/view/chatView/chat_appBar.dart';
import 'package:tito_app/src/view/chatView/chat_body.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tito_app/src/view/chatView/chat_bottom_detail.dart';
import 'package:tito_app/src/view/chatView/chat_llm.dart';
import 'package:tito_app/src/view/chatView/chat_speech_bubble.dart';

class Chat extends ConsumerStatefulWidget {
  final int id;

  const Chat({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchDebateInfo();
  }

  Future<void> _fetchDebateInfo() async {
    final chatViewModel = ref.read(chatInfoProvider.notifier);

    await chatViewModel.fetchDebateInfo(widget.id);
    final webSocketService = ref.read(webSocketProvider);
    final loginInfo = ref.watch(loginInfoProvider);
    final debateInfo = ref.read(chatInfoProvider);

    chatViewModel.connectWebSocket();
    if (loginInfo != null) {
      final message = jsonEncode({
        "command": "ENTER",
        "userId": loginInfo.id,
        "debateId": debateInfo!.id,
      });
      webSocketService.sendMessage(message);

      webSocketService.stream.listen((message) {
        if (message.containsKey('content')) {
          setState(() {
            _messages.add(message);
          });
        }
      });
    } else {
      print("Error: Login info or Debate info is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final debateInfo = ref.watch(chatInfoProvider);
    final chatState = ref.read(chatInfoProvider);
    final chatViewModel = ref.read(chatInfoProvider.notifier);

    if (_messages.isNotEmpty) {
      if (_messages.length > 2) {
        chatState!.debateOwnerId = _messages[2]['userId'];
        chatViewModel.getInfo(chatState.debateOwnerId, context);

        if (_messages.length > 3) {
          chatState.debateJoinerId = _messages[3]['userId'];
          chatViewModel.getInfo(_messages[3]['userId'], context);
        }
      }

      if (_messages.isNotEmpty &&
          _messages.last.containsKey('ownerTurnCount') &&
          _messages.last.containsKey('joinerTurnCount')) {
        chatState!.debateOwnerTurnCount = _messages.last['ownerTurnCount'];
        chatState.debateJoinerTurnCount = _messages.last['joinerTurnCount'];
      }
    }
    if (debateInfo == null) {
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SpinKitThreeBounce(
            color: ColorSystem.grey3,
            size: 30.sp,
            duration: Duration(seconds: 2), //속도 설정
          ),
        ),
      );
    }

    return _BasicDebate(
      id: widget.id,
      debateInfo: debateInfo,
    );
  }
}

class _BasicDebate extends ConsumerWidget {
  final int id;
  final DebateInfo? debateInfo;

  const _BasicDebate({
    required this.id,
    required this.debateInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.read(chatInfoProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: ChatAppbar(id: id), // id 전달
      ),
      body: Stack(
        children: [
          ChatBody(id: id),
          chatState!.explanation != null &&
                  chatState.explanation!.any((e) => e.isNotEmpty)
              ? SlidingUpPanel(
                  header: Container(
                    padding: EdgeInsets.only(top: 8.h),
                    width: MediaQuery.sizeOf(context).width,
                    alignment: Alignment.center, // 컨테이너 내부에서 중앙 정렬
                    child: SvgPicture.asset('assets/icons/panel_line.svg'),
                  ),
                  maxHeight: 762.h,
                  minHeight: 300.h,
                  panel: ChatLlm(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  boxShadow: [],
                )
              : SizedBox(
                  width: 0,
                ),
          chatState.explanation != null &&
                  chatState.explanation!.any((e) => e.isNotEmpty)
              ? Positioned(
                  bottom: 0, // 패널의 위에 ChatBottomDetail이 보이도록 위치 조정
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      ChatBottomDetail(id: id),
                    ],
                  ),
                )
              : SizedBox(
                  width: 0,
                ),
        ],
      ),
    );
  }
}
