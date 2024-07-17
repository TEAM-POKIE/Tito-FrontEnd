import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/types.dart' as types;

class ChatListView extends ConsumerWidget {
  final String id;

  const ChatListView({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatViewModel = ref.watch(chatProviders(id).notifier);
    final loginInfo = ref.read(loginInfoProvider);

    return Expanded(
      child: StreamBuilder<List<types.Message>>(
        stream: chatViewModel.messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading messages'));
          }

          final messages = snapshot.data ?? [];

          return GroupedListView<types.Message, DateTime>(
            elements: messages,
            groupBy: (message) => DateTime(
              DateTime.fromMillisecondsSinceEpoch(message.createdAt).year,
              DateTime.fromMillisecondsSinceEpoch(message.createdAt).month,
              DateTime.fromMillisecondsSinceEpoch(message.createdAt).day,
            ),
            groupHeaderBuilder: (types.Message message) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${DateTime.fromMillisecondsSinceEpoch(message.createdAt).year}-${DateTime.fromMillisecondsSinceEpoch(message.createdAt).month}-${DateTime.fromMillisecondsSinceEpoch(message.createdAt).day}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            itemBuilder: (context, types.Message message) {
              final isMyMessage = message.author.id == loginInfo!.nickname;
              final formattedTime = TimeOfDay.fromDateTime(
                      DateTime.fromMillisecondsSinceEpoch(message.createdAt))
                  .format(context);

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
                        color:
                            isMyMessage ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((message as types.TextMessage).text),
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
            useStickyGroupSeparators: true,
            floatingHeader: true,
            order: GroupedListOrder.ASC,
          );
        },
      ),
    );
  }
}
