import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/chat_state_provider.dart';
import 'package:tito_app/core/provider/login_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/data/models/types.dart' as types;
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

class ChatState {
  final List<types.Message> messages;
  final bool isFirstMessage;
  final bool? isVisible;
  final String fadeText;
  final String roomId;
  final Map<String, dynamic>? debateData;

  ChatState({
    this.messages = const [],
    this.isFirstMessage = true,
    this.fadeText = '첫 채팅을 입력해주세요!',
    this.debateData,
    this.isVisible = true,
    required this.roomId,
  });

  ChatState copyWith({
    List<types.Message>? messages,
    bool? isFirstMessage,
    bool? isVisible,
    String? fadeText,
    String? roomId,
    Map<String, dynamic>? debateData,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isFirstMessage: isFirstMessage ?? this.isFirstMessage,
      fadeText: fadeText ?? this.fadeText,
      isVisible: isVisible ?? this.isVisible,
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
  late StreamController<List<types.Message>> _messagesController;
  final ApiService apiService = ApiService(DioClient.dio);

  ChatViewModel(this.ref, String roomId) : super(ChatState(roomId: roomId)) {
    _messagesController = StreamController<List<types.Message>>.broadcast();
    init();
  }

  Stream<List<types.Message>> get messagesStream => _messagesController.stream;

  void init() {
    channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.1.6:4040/ws/${state.roomId}'));
    channel.stream.listen(_onReceiveMessage);

    fetchDebateData();
    _fetchMessages();
    _hideBubbleAfterDelay();
  }

  Future<List<types.Message>> loadInitialMessages() async {
    print('Loading initial messages...');
    await fetchDebateData();
    await _fetchMessages();
    return state.messages;
  }

  void _hideBubbleAfterDelay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        state = state.copyWith(isVisible: false);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    channel.sink.close();
    _messagesController.close();
    super.dispose();
  }

  void _onReceiveMessage(dynamic message) {
    final decodedMessage = json.decode(message);

    if (decodedMessage['type'] == 'turnUpdate') {
      state = state.copyWith(
        debateData: {
          ...state.debateData!,
          'myTurn': decodedMessage['myTurn'],
          'opponentTurn': decodedMessage['opponentTurn'],
        },
      );
      return;
    }

    final chatMessage = types.TextMessage(
      author: types.User(id: decodedMessage['senderId'] ?? ''),
      createdAt:
          DateTime.parse(decodedMessage['timestamp']).millisecondsSinceEpoch,
      id: decodedMessage['id'] ?? '',
      text: decodedMessage['text'] ?? '',
    );

    final updatedMessages = [...state.messages, chatMessage];
    updatedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    state = state.copyWith(
      messages: updatedMessages,
    );
    _messagesController.add(updatedMessages);
  }

  Future<void> _fetchMessages() async {
    try {
      print('Fetching messages...');
      final data = await apiService.getData('chat_list/${state.roomId}');
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

        final updatedMessages = loadedMessages
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        state = state.copyWith(
          messages: updatedMessages,
        );
        _messagesController.add(updatedMessages);
      } else {
        print('No messages data found.');
        _messagesController.add(state.messages);
      }
    } catch (e) {
      print('Error fetching messages: $e');
      _messagesController.add(state.messages);
    }
  }

  Future<void> fetchDebateData() async {
    try {
      final data = await apiService.getData('debate_list/${state.roomId}');

      if (data != null) {
        state = state.copyWith(
          debateData: data,
        );
      } else {
        print('Failed to load debate data');
      }
    } catch (e) {
      print('Error fetching debate data: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    final loginInfo = ref.read(loginInfoProvider);
    final chatState = state;
    if (loginInfo != null && chatState.debateData != null) {
      final debateData = chatState.debateData!;

      int patchDate;

      if (loginInfo.nickname == debateData['myNick']) {
        patchDate = ++debateData['myTurn'];
        await apiService
            .patchData('debate_list/${state.roomId}', {'myTurn': patchDate});
      } else {
        patchDate = ++debateData['opponentTurn'];
        await apiService.patchData(
            'debate_list/${state.roomId}', {'opponentTurn': patchDate});
      }

      final newMessage = {
        'text': controller.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      controller.clear();
      channel.sink.add(json.encode({
        ...newMessage,
        'type': 'message',
        'myTurn': debateData['myTurn'],
        'opponentTurn': debateData['opponentTurn'],
      }));

      final updatedMessages = [
        ...state.messages,
        types.TextMessage(
          author: types.User(id: loginInfo.nickname),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: newMessage['id'] ?? '',
          text: newMessage['text'] ?? '',
        ),
      ];
      updatedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      state = state.copyWith(
        messages: updatedMessages,
        debateData: debateData,
      );
      _messagesController.add(updatedMessages);

      final chatData = {
        'senderId': loginInfo.nickname,
        'text': newMessage['text'] ?? '',
        'timestamp': newMessage['timestamp'],
      };
      await apiService.postData('chat_list/${state.roomId}', chatData);
    }
  }

  Future<void> sendMessage() async {
    await _sendMessage();
  }

  void back(BuildContext context) {
    final chatState = state;

    if (chatState.debateData?['myTurn'] == 0) {
      context.pop();
    } else {
      context.go('/list');
    }
  }
}
