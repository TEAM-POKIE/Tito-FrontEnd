import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/live_comment.dart';
import 'package:tito_app/src/view/chatView/live_send_view.dart';
import 'package:tito_app/src/viewModel/live_comment_viewModel.dart';

class LiveComment extends ConsumerStatefulWidget {
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
  _LiveCommentState createState() => _LiveCommentState();
}

class _LiveCommentState extends ConsumerState<LiveComment> {
  late Future<void> _initialMessagesFuture;

  @override
  void initState() {
    super.initState();
    final liveCommentViewModel =
        ref.read(liveCommentProvider(widget.id).notifier);
    _initialMessagesFuture = liveCommentViewModel.fetchInitialMessages();
  }

  @override
  Widget build(BuildContext context) {
    final liveCommentViewModel =
        ref.watch(liveCommentProvider(widget.id).notifier);

    return FutureBuilder<void>(
      future: _initialMessagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }

        return Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: liveCommentViewModel.messagesStream,
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                          ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (streamSnapshot.hasError) {
                    return const Center(child: Text('Error loading messages'));
                  } else if (!streamSnapshot.hasData ||
                      streamSnapshot.data!.isEmpty) {
                    return const Center(child: Text('No comments yet'));
                  }

                  final messages = streamSnapshot.data!;
                  return ListView.builder(
                    controller: widget.scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: Text(
                                message.username[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                  );
                },
              ),
            ),
            LiveSendView(username: widget.username, roomId: widget.id),
          ],
        );
      },
    );
  }
}
