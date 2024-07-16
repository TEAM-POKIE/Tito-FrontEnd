import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:tito_app/core/provider/turn_provider.dart';
import 'package:tito_app/src/widgets/reuse/debate_popup.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/data/models/types.dart' as types;
import 'package:tito_app/core/constants/api_path.dart';

// Chat state class
class ChatState {
  final List<types.Message> messages;
  final bool isFirstMessage;
  final String fadeText;
  final String roomId;

  final Map<String, dynamic>? debateData;

  ChatState({
    this.messages = const [],
    this.isFirstMessage = true,
    this.fadeText = '첫 채팅을 입력해주세요!',
    this.debateData,
    required this.roomId,
  });

  ChatState copyWith({
    List<types.Message>? messages,
    bool? isFirstMessage,
    String? fadeText,
    String? roomId,
    Map<String, dynamic>? debateData,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isFirstMessage: isFirstMessage ?? this.isFirstMessage,
      fadeText: fadeText ?? this.fadeText,
      roomId: roomId ?? this.roomId,
      debateData: debateData ?? this.debateData,
    );
  }
}

class ChatViewModel extends StateNotifier<ChatState> {
  final Ref ref;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  late WebSocketChannel channel;

  ChatViewModel(this.ref, String roomId) : super(ChatState(roomId: roomId)) {
    _init();
  }

  void _init() {
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:4040/ws'));
    channel.stream.listen(_onReceiveMessage);
    _fetchDebateData();
    _fetchMessages();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    channel.sink.close();
    super.dispose();
  }

  void _onReceiveMessage(dynamic message) {
    final decodedMessage = json.decode(message);
    final chatMessage = types.TextMessage(
      author: types.User(id: decodedMessage['senderId'] ?? ''),
      createdAt:
          DateTime.parse(decodedMessage['timestamp']).millisecondsSinceEpoch,
      id: decodedMessage['id'] ?? '',
      text: decodedMessage['text'] ?? '',
    );

    state = state.copyWith(
      messages: [chatMessage, ...state.messages],
    );
  }

  Future<void> _fetchMessages() async {
    final data = await ApiService.getData('chat_list/${state.roomId}');
    if (data != null) {
      final loadedMessages = <types.Message>[];
      data.forEach((key, value) {
        loadedMessages.add(types.TextMessage(
          author: types.User(id: value['senderId'] ?? ''),
          createdAt:
              DateTime.parse(value['timestamp'] ?? '').millisecondsSinceEpoch,
          id: key,
          text: value['text'] ?? '',
        ));
      });

      state = state.copyWith(
        messages: loadedMessages.reversed.toList(),
      );
    }
  }

  Future<void> _fetchDebateData() async {
    final data = await ApiService.getData('debate_list/${state.roomId}');
    if (data != null) {
      state = state.copyWith(
        debateData: data,
      );
    } else {
      print('Failed to load debate data');
    }
  }

  Future<void> _sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }
    final turnIndex = ref.read(turnProvider.notifier);
    final loginInfo = ref.read(loginInfoProvider);
    if (loginInfo == null) {
      return;
    }
    final newMessage = {
      'text': controller.text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    final updateData = {'turnId': loginInfo.nickname};
    final isUpdated =
        await ApiService.patchData('debate_list/${state.roomId}', updateData);

    if (isUpdated) {
      state = state.copyWith(
        debateData: {
          ...?state.debateData,
          'turnId': loginInfo.nickname,
        },
      );

      controller.clear();
      channel.sink.add(json.encode(newMessage));

      if (state.isFirstMessage) {
        final visibleDebateData = {'visibleDebate': true};
        final isVisibleUpdated = await ApiService.patchData(
            'debate_list/${state.roomId}', visibleDebateData);

        if (isVisibleUpdated) {
          state = state.copyWith(
            isFirstMessage: false,
            fadeText: '첫 채팅 작성을 완료했습니다!\n 토론 참여자를 기다려보세요 !',
            debateData: {
              ...?state.debateData,
              ...visibleDebateData,
            },
          );
          print('Debate room created successfully.');
        } else {
          print('Failed to create debate room.');
        }
      }

      state = state.copyWith(
        messages: [
          ...state.messages,
          types.TextMessage(
            author: types.User(id: loginInfo.nickname),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: newMessage['id'] ?? '',
            text: newMessage['text'] ?? '',
          ),
        ],
      );

      final chatData = {
        'senderId': loginInfo.nickname,
        'text': newMessage['text'] ?? '',
        'timestamp': newMessage['timestamp'],
      };
      await ApiService.postData('chat_list/${state.roomId}', chatData);
    }
  }

  Future<void> sendMessage() async {
    await _sendMessage();
  }

  Future<bool> showDebatePopup(BuildContext context) async {
    final loginInfo = ref.read(loginInfoProvider);
    if (loginInfo == null) {
      return false;
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DebatePopup(
          debateId: state.roomId,
          nick: loginInfo.nickname,
          onUpdate: (opponentNick) {
            state = state.copyWith(
              debateData: {
                ...?state.debateData,
                'opponentNick': opponentNick,
              },
            );
          },
        );
      },
    );

    return result ?? false; // return false if result is null
  }

  void back(BuildContext context) {
    if (state.isFirstMessage) {
      context.pop(context);
    } else {
      context.go('/list');
    }
  }
}
