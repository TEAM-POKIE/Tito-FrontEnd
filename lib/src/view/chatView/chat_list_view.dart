import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/chat_view_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:tito_app/core/provider/websocket_provider.dart';
import 'package:tito_app/src/data/models/login_info.dart';

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
  bool _isTyping = false;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchDebateInfo();
      _subscribeToMessages();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _fetchDebateInfo() async {
    final chatViewModel = ref.read(chatInfoProvider.notifier);
    await chatViewModel.fetchDebateInfo(widget.id);
  }

  void _handlePopupIfNeeded(Map<String, dynamic> message, LoginInfo loginInfo) {
    final chatState = ref.read(chatInfoProvider);
    final popupViewModel = ref.read(popupProvider.notifier);

    if (message['command'] == 'TIMING_BELL_REQ' &&
        loginInfo.id != message['userId'] &&
        message['content'] == 'timing bell request') {
      if (chatState!.debateJoinerId == loginInfo.id ||
          chatState.debateOwnerId == loginInfo.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            popupViewModel.showTimingReceive(context);
            chatState.canTiming = false;
          }
        });
      }
    } else if (message['command'] == 'TIMING_BELL_RES') {
      chatState!.canTiming = false;
    } else if (message['content'] == "토론이 종료 되었습니다.") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          popupViewModel.showEndPopup(context);
        }
      });
    }
  }

  void _subscribeToMessages() {
    final webSocketService = ref.read(webSocketProvider);
    final loginInfo = ref.watch(loginInfoProvider);

    _subscription = webSocketService.stream.listen((message) {
      if (message.containsKey('content')) {
        if (mounted) {
          setState(() {
            _messages.add(message);
            if (loginInfo != null) {
              _handlePopupIfNeeded(message, loginInfo);
            }
          });
        }
      }
      if (message['command'] == 'TYPING') {
        if (mounted) {
          setState(() {
            _isTyping = true;
          });
        }
        _typingTimer?.cancel(); // 기존 타이머를 취소
        _typingTimer = Timer(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo = ref.watch(loginInfoProvider);
    final chatState = ref.watch(chatInfoProvider);

    if (chatState == null || loginInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: chatState.debateJoinerId == loginInfo.id ||
                  chatState.debateOwnerId == loginInfo.id
              ? JoinerChatList(
                  messages: _messages,
                  loginInfo: loginInfo,
                  isTyping: _isTyping,
                )
              : ParticipantsList(
                  messages: _messages,
                  loginInfo: loginInfo,
                  isTyping: _isTyping,
                ),
        ),
        if (_isTyping) TypingIndicator(),
      ],
    );
  }
}

class JoinerChatList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final LoginInfo loginInfo;
  final bool isTyping;

  const JoinerChatList({
    required this.messages,
    required this.loginInfo,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMyMessage = message['userId'] == loginInfo.id;
        final chatMessage = message['command'] == 'CHAT';
        final notifyMessage = message['command'] == 'NOTIFY';

        final formattedTime = TimeOfDay.now().format(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            chatMessage
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: isMyMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isMyMessage)
                          const CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 250),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: ColorSystem.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(message['content'] ?? ''),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                          ],
                        ),
                        if (isMyMessage) const SizedBox(width: 8),
                        if (isMyMessage)
                          const CircleAvatar(child: Icon(Icons.person)),
                      ],
                    ),
                  )
                : notifyMessage
                    ? Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Center(child: Text(message['content'] ?? '')),
                      )
                    : SizedBox(
                        width: 0,
                      ),
            index == messages.length - 1 && message['userId'] == loginInfo.id
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '답변 작성중',
                          style: FontSystem.KR16B
                              .copyWith(color: ColorSystem.purple),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: 0,
                  ),
          ],
        );
      },
    );
  }
}

class ParticipantsList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final LoginInfo loginInfo;
  final bool isTyping;

  const ParticipantsList({
    required this.messages,
    required this.loginInfo,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMyMessage = message['userId'] == messages[2]['userId'];
        final chatMessage = message['command'] == 'CHAT';
        final formattedTime = TimeOfDay.now().format(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: chatMessage
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: isMyMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMyMessage)
                            const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 8),
                          Column(
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
                                child: Text(message['content'] ?? ''),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black54),
                              ),
                            ],
                          ),
                          if (isMyMessage) const SizedBox(width: 8),
                          if (isMyMessage)
                            const CircleAvatar(child: Icon(Icons.person)),
                        ],
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Center(child: Text(message['content'] ?? '')),
                    ),
            ),
            if (isTyping && index == messages.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TypingIndicator(),
              ),
          ],
        );
      },
    );
  }
}

class TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.more_horiz, color: ColorSystem.purple),
        SizedBox(width: 8),
        Text(
          '답변 작성중...',
          style: TextStyle(color: ColorSystem.purple),
        ),
      ],
    );
  }
}
