import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

// Chat state class
class LiveState {
  final List<LiveMessage> messages;

  LiveState({this.messages = const []});

  LiveState copyWith({List<LiveMessage>? messages}) {
    return LiveState(messages: messages ?? this.messages);
  }
}

class LiveMessage {
  final String username;
  final String message;

  LiveMessage({required this.username, required this.message});
}

class LiveCommentViewmodel extends StateNotifier<LiveState> {
  final WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  LiveCommentViewmodel(this.channel) : super(LiveState()) {
    _init();
  }

  void _init() {
    channel.stream.listen(_onReceiveMessage);
  }

  void _onReceiveMessage(dynamic message) {
    final decodedMessage = json.decode(message);
    final liveComment = LiveMessage(
      username: decodedMessage['username'],
      message: decodedMessage['message'],
    );

    state = state.copyWith(messages: [liveComment, ...state.messages]);
  }

  void sendMessage(String username) {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      final newMessage = json.encode({
        'username': username,
        'message': message,
      });
      channel.sink.add(newMessage);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    channel.sink.close();
    super.dispose();
  }
}
