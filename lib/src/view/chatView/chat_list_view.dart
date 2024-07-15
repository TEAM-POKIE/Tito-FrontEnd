import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/turn_provider.dart';
import 'package:tito_app/src/data/models/types.dart' as types;

class ChatListView extends ConsumerWidget {
  final String id;

  const ChatListView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProviders(id));
    final loginInfo = ref.read(loginInfoProvider);
    final turnIndex = ref.watch(turnProvider.notifier);
    // GroupedListView
    return turnIndex.state != 0
        ? Expanded(
            child: GroupedListView<types.Message, DateTime>(
              elements: chatState.messages,
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
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
                          color: Colors.white,
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
            ),
          )
        : const SizedBox(
            height: 0,
          );
  }
}
