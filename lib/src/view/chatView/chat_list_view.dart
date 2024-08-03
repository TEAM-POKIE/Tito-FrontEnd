import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';

class ChatListView extends ConsumerStatefulWidget {
  final int id;

  const ChatListView({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends ConsumerState<ChatListView> {
  List<Map<String, dynamic>> _messages = [];
  late StreamSubscription<Map<String, dynamic>> _subscription;

  @override
  void initState() {
    super.initState();
    _fetchDebateInfo();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _fetchDebateInfo() async {
    final chatViewModel = ref.read(chatInfoProvider.notifier);
    await chatViewModel.fetchDebateInfo(widget.id);
  }

  void _subscribeToMessages() {
    final webSocketService = ref.read(webSocketProvider);
    _subscription = webSocketService.stream.listen((message) {
      if (message.containsKey('content')) {
        setState(() {
          _messages.add(message);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);

    return ListView.builder(
      controller: ScrollController(),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMyMessage = message['userId'] == loginInfo?.id;
        final formattedTime = TimeOfDay.now().format(context);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment:
                isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMyMessage) const CircleAvatar(child: Icon(Icons.person)),
              if (!isMyMessage) const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(maxWidth: 250),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: isMyMessage ? Colors.blue[100] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message['content'] ?? ''),
                    const SizedBox(height: 5),
                    Text(
                      formattedTime,
                      style:
                          const TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              if (isMyMessage) const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}
