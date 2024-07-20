import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/api_path.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class LiveState {
  final List<Message> messages;
  String? userNickname;

  LiveState({this.messages = const [], this.userNickname});

  LiveState copyWith({List<Message>? messages, String? userNickname}) {
    return LiveState(
      messages: messages ?? this.messages,
      userNickname: userNickname ?? this.userNickname,
    );
  }
}

class LiveCommentViewModel extends StateNotifier<LiveState> {
  final WebSocketChannel channel;
  final TextEditingController controller = TextEditingController();
  final StreamController<List<Message>> _messagesController =
      StreamController.broadcast();
  final String roomId;

  LiveCommentViewModel(this.channel, this.roomId) : super(LiveState()) {
    fetchInitialMessages();
    channel.stream.listen((message) {
      final parsedMessage = _parseMessage(message);
      if (parsedMessage != null) {
        state = state.copyWith(
          messages: [parsedMessage, ...state.messages],
        );
        _messagesController.add(state.messages);
      }
    });
  }

  Stream<List<Message>> get messagesStream => _messagesController.stream;

  Future<void> fetchInitialMessages() async {
    try {
      final data = await ApiService.getData('live_comments/$roomId');

      if (data != null) {
        final messages =
            data.entries.map((e) => Message.fromJson(e.value)).toList();
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // 메시지 정렬
        state = state.copyWith(messages: messages);
        _messagesController.add(state.messages);
      } else {
        print('Failed to fetch messages.');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<List<Message>> loadInitialMessages() async {
    await fetchInitialMessages();
    return state.messages;
  }

  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: state.userNickname ?? 'Unknown', // null 값을 방지
        message: message,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      final fullMessage = jsonEncode(newMessage.toJson());
      channel.sink.add(fullMessage);

      // Local state update for immediate feedback
      state = state.copyWith(
        messages: [newMessage, ...state.messages],
      );
      _messagesController.add(state.messages);

      // Save message to API
      final response = await ApiService.postData(
        'live_comments/$roomId',
        newMessage.toJson(),
      );

      if (!response) {
        print('Failed to save message.');
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    channel.sink.close(status.goingAway);
    _messagesController.close();
    super.dispose();
  }

  Message? _parseMessage(String message) {
    try {
      final parsed = jsonDecode(message);
      return Message.fromJson(parsed);
    } catch (e) {
      print('Error parsing message: $e');
      return null;
    }
  }
}

class Message {
  final String id;
  final String username;
  final String message;
  final int createdAt;

  Message({
    required this.id,
    required this.username,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      username: json['username'] ?? 'Unknown', // null 값을 방지
      message: json['message'] ?? '',
      createdAt: json['createdAt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'message': message,
      'createdAt': createdAt,
    };
  }
}
