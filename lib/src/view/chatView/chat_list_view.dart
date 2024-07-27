import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';

import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/src/data/models/types.dart' as types;

class ChatListView extends ConsumerStatefulWidget {
  const ChatListView({
    super.key,
  });

  @override
  ConsumerState<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends ConsumerState<ChatListView> {
  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProviders);
    final loginInfo = ref.read(loginInfoProvider);

    if (chatState.debateData!['opponentNick'] == loginInfo?.nickname ||
        chatState.debateData!['myNick'] == loginInfo?.nickname) {
      return PartiChatList();
    } else {
      return AudienceChatList();
    }
  }
}

class PartiChatList extends ConsumerStatefulWidget {
  const PartiChatList({
    super.key,
  });

  @override
  ConsumerState<PartiChatList> createState() => _PartiChatListState();
}

class _PartiChatListState extends ConsumerState<PartiChatList> {
  late ScrollController _scrollController;
  late Future<List<types.Message>> _initialMessagesFuture;
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final chatViewModel = ref.read(chatProviders.notifier);
    _initialMessagesFuture = chatViewModel.loadInitialMessages();
    _initialMessagesFuture.then((messages) {
      if (mounted) {
        setState(() {
          _messages = messages;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = ref.watch(chatProviders.notifier);
    final loginInfo = ref.read(loginInfoProvider);

    return FutureBuilder<List<types.Message>>(
      future: _initialMessagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('메시지를 불러오는 중 오류가 발생했습니다.'));
        }

        return StreamBuilder<List<types.Message>>(
          stream: chatViewModel.messagesStream,
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasError) {
              return const Center(child: Text('메시지를 불러오는 중 오류가 발생했습니다.'));
            }

            if (streamSnapshot.hasData) {
              final newMessages = streamSnapshot.data!;
              final messageIds = _messages.map((m) => m.id).toSet();
              final nonDuplicateMessages =
                  newMessages.where((m) => !messageIds.contains(m.id)).toList();
              _messages = [
                ..._messages,
                ...nonDuplicateMessages,
              ];
              _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              }
            });

            return ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMyMessage = message.author.id == loginInfo?.nickname;
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
            );
          },
        );
      },
    );
  }
}

class AudienceChatList extends ConsumerStatefulWidget {
  const AudienceChatList({
    super.key,
  });

  @override
  ConsumerState<AudienceChatList> createState() => _AudienceChatListState();
}

class _AudienceChatListState extends ConsumerState<AudienceChatList> {
  late ScrollController _scrollController;
  late Future<List<types.Message>> _initialMessagesFuture;
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final chatViewModel = ref.read(chatProviders.notifier);

    _initialMessagesFuture = chatViewModel.loadInitialMessages();

    _initialMessagesFuture.then((messages) {
      if (mounted) {
        setState(() {
          _messages = messages;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = ref.watch(chatProviders.notifier);
    final chatState = ref.watch(chatProviders);
    final loginInfo = ref.read(loginInfoProvider);

    return FutureBuilder<List<types.Message>>(
      future: _initialMessagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('메시지를 불러오는 중 오류가 발생했습니다.'));
        }

        return StreamBuilder<List<types.Message>>(
          stream: chatViewModel.messagesStream,
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasError) {
              return const Center(child: Text('메시지를 불러오는 중 오류가 발생했습니다.'));
            }

            if (streamSnapshot.hasData) {
              final newMessages = streamSnapshot.data!;
              final messageIds = _messages.map((m) => m.id).toSet();
              final nonDuplicateMessages =
                  newMessages.where((m) => !messageIds.contains(m.id)).toList();
              _messages = [
                ..._messages,
                ...nonDuplicateMessages,
              ];
              _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              }
            });

            return Container(
              color: ColorSystem.ligthGrey,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMyMessage =
                      message.author.id == chatState.debateData!['myNick'];
                  final formattedTime = TimeOfDay.fromDateTime(
                          DateTime.fromMillisecondsSinceEpoch(
                              message.createdAt))
                      .format(context);

                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: isMyMessage
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isMyMessage)
                                const CircleAvatar(child: Icon(Icons.person)),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: isMyMessage
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 250),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: ColorSystem.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text((message as types.TextMessage)
                                            .text),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    formattedTime,
                                    style: FontSystem.KR10B
                                        .copyWith(color: ColorSystem.grey),
                                  ),
                                ],
                              ),
                              if (isMyMessage) const SizedBox(width: 8),
                              if (isMyMessage)
                                CircleAvatar(child: Icon(Icons.person)),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ));
                },
              ),
            );
          },
        );
      },
    );
  }
}
