import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/view/chatView/chat_appBar.dart';
import 'package:tito_app/src/view/chatView/chat_body.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    final chatState = ref.read(chatInfoProvider);
    await chatViewModel.fetchDebateInfo(widget.id);
    final webSocketService = ref.read(webSocketProvider);
    final loginInfo = ref.watch(loginInfoProvider);
    final debateInfo = ref.read(chatInfoProvider);

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

    if (_messages.isNotEmpty) {
      if (_messages.length > 2) {
        chatState!.debateOwnerId = _messages[2]['userId'];
        if (_messages.length > 3) {
          chatState.debateJoinerId = _messages[3]['userId'];
        }
      }
      chatState!.debateOwnerTurnCount = _messages.last['ownerTurnCount'];
      chatState.debateJoinerTurnCount = _messages.last['joinerTurnCount'];
    }
    if (debateInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _BasicDebate(
      id: widget.id,
      debateInfo: debateInfo,
    );
  }
}

class _BasicDebate extends StatelessWidget {
  final int id;
  final DebateInfo? debateInfo;

  const _BasicDebate({
    required this.id,
    required this.debateInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ChatAppbar(id: id), // id 전달
      ),
      body: ChatBody(id: id), // id 전달
    );
  }
}
