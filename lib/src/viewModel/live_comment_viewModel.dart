import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class LiveCommentViewModel extends StateNotifier<LiveState> {
  final WebSocketChannel channel;
  final TextEditingController controller = TextEditingController();

  LiveCommentViewModel(this.channel) : super(LiveState()) {
    channel.stream.listen((message) {
      final parsedMessage = _parseMessage(message);
      if (parsedMessage != null) {
        state = state.copyWith(
          messages: [...state.messages, parsedMessage],
        );
      }
    });
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      final fullMessage = jsonEncode({'username': 'User', 'message': message});
      channel.sink.add(fullMessage);
    }
  }

  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  Message? _parseMessage(String message) {
    try {
      final parsed = jsonDecode(message);
      return Message(username: parsed['username'], message: parsed['message']);
    } catch (e) {
      print('Error parsing message: $e');
      return null;
    }
  }
}

class LiveState {
  final List<Message> messages;

  LiveState({this.messages = const []});

  LiveState copyWith({List<Message>? messages}) {
    return LiveState(messages: messages ?? this.messages);
  }
}

class Message {
  final String username;
  final String message;

  Message({required this.username, required this.message});
}
