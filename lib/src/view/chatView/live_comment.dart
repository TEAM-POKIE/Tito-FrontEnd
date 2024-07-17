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
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        message.username[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(message.message),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        LiveSendView(username: username),
      ],
    );
  }
}
