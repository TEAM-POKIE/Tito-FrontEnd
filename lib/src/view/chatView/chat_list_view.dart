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
  final List<Map<String, dynamic>> _messages = [];

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);
    final webSocketService = ref.watch(webSocketProvider);
    final chatState = ref.read(chatInfoProvider);

    return StreamBuilder<Map<String, dynamic>>(
      stream: webSocketService.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('메시지를 불러오는 중 오류가 발생했습니다.'));
        }

        if (snapshot.hasData) {
          final message = snapshot.data!;
          if (message.containsKey('content')) {
            _messages.add(message);
          }
        }

        if (_messages.isNotEmpty) {
          chatState!.debateOwnerTurnCount = _messages.last['ownerTurnCount'];
          chatState.debateJoinerTurnCount = _messages.last['joinerTurnCount'];
          print(chatState.debateJoinerTurnCount);
          print(chatState.debateOwnerTurnCount);
        }

        return ListView.builder(
          controller: ScrollController(),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            final isMyMessage = message['userId'] == loginInfo?.id;
            final formattedTime = TimeOfDay.now().format(context);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: isMyMessage
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!isMyMessage)
                    const CircleAvatar(child: Icon(Icons.person)),
                  if (!isMyMessage) const SizedBox(width: 8),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black54),
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
      },
    );
  }
}
