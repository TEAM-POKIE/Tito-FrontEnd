import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/data/models/login_info.dart';
import 'package:tito_app/src/view/chatView/chat_appBar.dart';
import 'package:tito_app/src/view/chatView/chat_body.dart';
import 'package:tito_app/src/view/chatView/live_comment.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class Chat extends ConsumerStatefulWidget {
  final int turn = 0;

  const Chat({
    super.key,
  });

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  late WebSocketChannel channel;
  late String myNick;

  // @override
  // void initState() {
  //   super.initState();
  //   // WebSocket 서버와 연결 설정
  //   channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.6:4040/ws'));

  //   // WebSocket 서버로부터 메시지를 받을 때마다 상태 업데이트
  //   channel.stream.listen((message) {
  //     final data = json.decode(message);
  //     if (data['type'] == 'update_myNick') {
  //       setState(() {
  //         myNick = data['myNick'];
  //       });
  //     }
  //   });

  //   // 초기 데이터를 가져오는 HTTP 요청
  //   _fetchInitialData();
  // }

  // Future<void> _fetchInitialData() async {
  //   final apiService = ApiService(DioClient.dio);
  //   final data = await apiService.getData('debate_list/');
  //   if (data != null && data.containsKey('myNick')) {
  //     setState(() {
  //       myNick = data['myNick'];
  //     });
  //   }
  // }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProviders);
    final loginInfo = ref.watch(loginInfoProvider);

    // if (loginInfo == null || chatState.debateData == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return _BasicDebate(
      chatState: chatState,
    );
  }
}

class _BasicDebate extends StatelessWidget {
  final ChatState chatState;

  const _BasicDebate({
    required this.chatState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ChatAppbar(), // id 전달
      ),
      body: ChatBody(),
    );
  }
}
