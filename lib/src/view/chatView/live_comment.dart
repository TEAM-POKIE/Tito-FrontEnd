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
  late Future<List<Message>> _initialMessagesFuture;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    final liveCommentViewModel =
        ref.read(liveCommentProvider(widget.id).notifier);
    _initialMessagesFuture = liveCommentViewModel.loadInitialMessages();
    _initialMessagesFuture.then((messages) {
      if (mounted) {
        setState(() {
          _messages = messages;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final liveCommentViewModel =
        ref.watch(liveCommentProvider(widget.id).notifier);

    return FutureBuilder<List<Message>>(
      future: _initialMessagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }

        if (snapshot.hasData) {
          _messages = snapshot.data!;
        }

        return Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: liveCommentViewModel.messagesStream,
                builder: (context, streamSnapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('메시지를 불러오는 중 오류가 발생했습니다.'));
                  }

                  if (streamSnapshot.hasData) {
                    final newMessages = streamSnapshot.data!;
                    final messageIds = _messages.map((m) => m.id).toSet();
                    final nonDuplicateMessages = newMessages
                        .where((m) => !messageIds.contains(m.id))
                        .toList();
                    _messages = [
                      ..._messages,
                      ...nonDuplicateMessages,
                    ];
                    _messages
                        .sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (widget.scrollController.hasClients) {
                      widget.scrollController.jumpTo(
                          widget.scrollController.position.maxScrollExtent);
                    }
                  });

                  return ListView.builder(
                    controller: widget.scrollController,
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
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
