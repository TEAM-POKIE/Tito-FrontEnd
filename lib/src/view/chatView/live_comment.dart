import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/live_comment.dart';
import 'package:tito_app/src/view/chatView/live_send_view.dart';

class LiveComment extends ConsumerWidget {
  final String username;
  final String id;
  final ScrollController scrollController;

  const LiveComment({
    super.key,
    required this.username,
    required this.id,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveState = ref.watch(liveCommentProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            reverse: true,
            itemCount: liveState.messages.length,
            itemBuilder: (context, index) {
              final message = liveState.messages[index];
              return ListTile(
                title: Text(message.username),
                subtitle: Text(message.message),
              );
            },
          ),
        ),
        LiveSendView(username: username),
      ],
    );
  }
}
